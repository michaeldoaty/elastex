defmodule Elastex.Integration.IndexTest do
  use ShouldI

  alias Elastex.Index

  def conn do
    %{url: "http://localhost:9200"}
  end


  having "no existing indicies" do

    setup context do
      Index.delete("twitter") |> Elastex.run(conn)

      :ok
    end


    test "create" do
      resp = Index.create("twitter") |> Elastex.run(conn)

      {:ok, %HTTPoison.Response{body: %{"acknowledged" => acknowledged}}} = resp
      assert acknowledged == true
    end


    test "create with body" do
      resp = %{number_of_shards: 3}
      |> Index.create("twitter")
      |> Elastex.run(conn)

      {:ok, %HTTPoison.Response{body: %{"acknowledged" => acknowledged}}} = resp
      assert acknowledged == true
    end


    test "put_mapping" do
      resp = %{mappings: %{tweet: %{properties: %{message: %{type: "text"}}}}}
      |> Index.put_mapping("twitter")
      |> Elastex.run(conn)

      {:ok, %HTTPoison.Response{body: %{"acknowledged" => acknowledged}}} = resp
      assert acknowledged == true
    end


  end




  having "existing index" do

    setup context do
      %{aliases: %{tweeter: %{}}}
      |> Index.create("twitter")
      |> Elastex.run(conn)

      Index.open("twitter") |> Elastex.run(conn)

      on_exit fn ->
        Index.delete("small_twitter") |> Elastex.run(conn)
        Index.delete("twitter") |> Elastex.run(conn)
      end

      :ok
    end


    test "delete" do
      resp = Index.delete("twitter") |> Elastex.run(conn)

      {:ok, %HTTPoison.Response{body: %{"acknowledged" => acknowledged}}} = resp
      assert acknowledged == true
    end


    test "get" do
      resp = Index.get("twitter") |> Elastex.run(conn)

      {:ok, %HTTPoison.Response{body: %{"twitter" => %{"settings" => %{"index" => %{"provided_name" => name}}}}}} = resp
      assert name == "twitter"
    end


    test "exists" do
      resp = Index.exists("twitter") |> Elastex.run(conn)

      {:ok, %HTTPoison.Response{body: "", status_code: status_code}} = resp
      assert status_code == 200
    end


    test "close" do
      resp = Index.close("twitter") |> Elastex.run(conn)

      {:ok, %HTTPoison.Response{body: %{"acknowledged" => acknowledged}}} = resp
      assert acknowledged == true
    end


    test "open" do
      resp = Index.open("twitter") |> Elastex.run(conn)

      {:ok, %HTTPoison.Response{body: %{"acknowledged" => acknowledged}}} = resp
      assert acknowledged == true
    end


    having "shrink prep" do
      setup context do
        %{settings: %{"index.routing.allocation.require._name": "shrink_node_name",
                      "index.blocks.write": true}}
        |> Index.update_settings
        |> Elastex.run(conn)
        :ok
      end


      test "shrink" do
        resp = Index.shrink("twitter", "small_twitter") |> Elastex.run(conn)

        {:ok, %HTTPoison.Response{body: %{"acknowledged" => acknowledged}}} = resp
        assert acknowledged == true
      end


      test "shrink with body" do
        body = %{settings: %{"index.number_of_replicas" => 1}}
        resp = Index.shrink(body, "twitter", "small_twitter") |> Elastex.run(conn)

        {:ok, %HTTPoison.Response{body: %{"acknowledged" => acknowledged}}} = resp
        assert acknowledged == true
      end
    end


    having "alias" do

      setup context do
        %{aliases: %{"logs_write" => %{}}}
        |> Index.create("logs-000001")
        |> Elastex.run(conn)

        on_exit fn ->
          Index.delete("logs-000001") |> Elastex.run(conn)
          Index.delete("logs-000002") |> Elastex.run(conn)
          Index.delete("logs_write") |> Elastex.run(conn)
          Index.delete("new_logs_write") |> Elastex.run(conn)
        end

        :ok
      end


      test "rollover" do
        resp = %{conditions: %{max_age: "1ms"}}
        |> Index.rollover("logs_write")
        |> Elastex.run(conn)

        {:ok, %HTTPoison.Response{body: %{"rolled_over" => rolled_over}}} = resp
        assert rolled_over == true
      end


      test "rollover with name" do
        resp = %{conditions: %{max_age: "1ms"}}
        |> Index.rollover("logs_write", "new_logs_write")
        |> Elastex.run(conn)

        {:ok, %HTTPoison.Response{body: %{"rolled_over" => rolled_over}}} = resp
        assert rolled_over == true
      end


      test "get_alias" do
        resp = Index.get_alias("logs-000001", "logs_write")
        |> Elastex.run(conn)

        {:ok, %HTTPoison.Response{body: %{"logs-000001" => %{}}, status_code: status_code}} = resp
        assert status_code == 200
      end


      test "delete_alias" do
        resp = Index.delete_alias("logs-000001", "logs_write")
        |> Elastex.run(conn)

        {:ok, %HTTPoison.Response{body: %{"acknowledged" => acknowledged}}} = resp
        assert acknowledged == true
      end


      test "alias_exists" do
        resp = Index.alias_exists("logs-000001", "logs_write")
        |> Elastex.run(conn)

        {:ok, %HTTPoison.Response{body: "", status_code: status_code}} = resp
        assert status_code == 200
      end

    end


    test "put_mapping with type" do
      resp = %{properties: %{message: %{type: "text"}}}
      |> Index.put_mapping("twitter", "tweet")
      |> Elastex.run(conn)

      {:ok, %HTTPoison.Response{body: %{"acknowledged" => acknowledged}}} = resp
      assert acknowledged == true
    end


    test "get_mapping" do
      resp = Index.get_mapping("twitter") |> Elastex.run(conn)

      {:ok, %HTTPoison.Response{body: %{"twitter" => %{"mappings" => %{}}}, status_code: status_code}} = resp
      assert status_code == 200
    end


    test "get_mapping with type" do
      %{properties: %{message: %{type: "text"}}}
      |> Index.put_mapping("twitter", "tweet")
      |> Elastex.run(conn)

      resp = Index.get_mapping("twitter", "tweet") |> Elastex.run(conn)

      {:ok, %HTTPoison.Response{body: %{}, status_code: status_code}} = resp
      assert status_code == 200
    end


    test "get_field_mapping" do
      mapping = %{"message" => %{"type" => "text"}}

      %{properties: mapping}
      |> Index.put_mapping("twitter", "tweet")
      |> Elastex.run(conn)

      resp = Index.get_field_mapping("twitter", "tweet", "message") |> Elastex.run(conn)

      {:ok, %HTTPoison.Response{
        body: %{"twitter" =>
                %{"mappings" =>
                  %{"tweet" =>
                    %{"message" =>
                      %{"mapping" => mapping_result}}}}}}} = resp

      assert mapping_result == mapping
    end


    test "type_exists" do
      %{properties: %{message: %{type: "text"}}}
      |> Index.put_mapping("twitter", "tweet")
      |> Elastex.run(conn)

      resp = Index.type_exists("twitter", "tweet") |> Elastex.run(conn)

      {:ok, %HTTPoison.Response{body: "", status_code: status_code}} = resp
      assert status_code == 200
    end


    test "aliases" do
      resp = %{actions: [%{add: %{index: "twitter", alias: "tweeter"}}]}
      |> Index.aliases
      |> Elastex.run(conn)

      {:ok, %HTTPoison.Response{body: %{"acknowledged" => acknowledged}}} = resp
      assert acknowledged == true
    end


    test "add_alias" do
      resp = Index.add_alias("twitter", "tweeter") |> Elastex.run(conn)

      {:ok, %HTTPoison.Response{body: %{"acknowledged" => acknowledged}}} = resp
      assert acknowledged == true
    end


    test "add_alias with body" do
      resp = %{routing: "12"}
      |> Index.add_alias("twitter", "tweeter")
      |> Elastex.run(conn)

      {:ok, %HTTPoison.Response{body: %{"acknowledged" => acknowledged}}} = resp
      assert acknowledged == true
    end


    test "update_settings" do
      resp = %{number_of_replicas: 4}
      |> Index.update_settings
      |> Elastex.run(conn)

      {:ok, %HTTPoison.Response{body: %{"acknowledged" => acknowledged}}} = resp
      assert acknowledged == true
    end


    test "update_settings with body" do
      resp = %{number_of_replicas: 4}
      |> Index.update_settings("twitter")
      |> Elastex.run(conn)

      {:ok, %HTTPoison.Response{body: %{"acknowledged" => acknowledged}}} = resp
      assert acknowledged == true
    end


    test "get_settings" do
      resp = Index.get_settings("twitter") |> Elastex.run(conn)

      {:ok, %HTTPoison.Response{body:
        %{"twitter" =>
          %{"settings" =>
            %{"index" =>
              %{"provided_name" => provided_name}}}}}} = resp

      assert provided_name == "twitter"
    end


    test "analyze" do
      resp = %{analyzer: "standard", text: "this is a test"}
      |> Index.analyze()
      |> Elastex.run(conn)

      {:ok, %HTTPoison.Response{body: %{"tokens" => _tokens}, status_code: status_code}} = resp
      assert status_code == 200
    end


    test "analyze with index" do
      resp = %{analyzer: "standard", text: "this is a test"}
      |> Index.analyze("twitter")
      |> Elastex.run(conn)

      {:ok, %HTTPoison.Response{body: %{"tokens" => _tokens}, status_code: status_code}} = resp
      assert status_code == 200
    end

    having "template tests" do
      setup context do
        Index.delete_template("template_1")

        :ok
      end

      test "add_template" do
        resp = %{template: "te*", settings: %{number_of_shards: 1}}
        |> Index.add_template("template_1")
        |> Elastex.run(conn)

        {:ok, %HTTPoison.Response{body: %{"acknowledged" => acknowledged}}} = resp
        assert acknowledged == true
      end


      having "existing template" do
        setup context do
          resp = %{template: "te*", settings: %{number_of_shards: 1}}
          |> Index.add_template("template_1")
          |> Elastex.run(conn)

          on_exit fn ->
            Index.delete_template("template_1")
          end

          :ok
        end


        test "delete_template" do
          resp = Index.delete_template("template_1") |> Elastex.run(conn)

          {:ok, %HTTPoison.Response{body: %{"acknowledged" => acknowledged}}} = resp
          assert acknowledged == true
        end


        test "get_template" do
          resp = Index.get_template("template_1") |> Elastex.run(conn)

          {:ok, %HTTPoison.Response{body:
            %{"template_1" =>
              %{"template" => template}}}} = resp

          assert template == "te*"
        end


        test "template_exists" do
          resp = Index.template_exists("template_1") |> Elastex.run(conn)

          {:ok, %HTTPoison.Response{body: "", status_code: status_code}} = resp
          assert status_code == 200
        end
      end
    end


    test "stats" do
      resp = Index.stats |> Elastex.run(conn)

      {:ok, %HTTPoison.Response{body: %{"_all" => _all}, status_code: status_code}} = resp
      assert status_code == 200
    end


    test "stats with index" do
      resp = Index.stats("twitter") |> Elastex.run(conn)

      {:ok, %HTTPoison.Response{body: %{"_all" => _all}, status_code: status_code}} = resp
      assert status_code == 200
    end


    test "segments" do
      resp = Index.segments |> Elastex.run(conn)

      {:ok, %HTTPoison.Response{body: %{"_shards" => _shards}, status_code: status_code}} = resp
      assert status_code == 200
    end


    test "segments with index" do
      resp = Index.segments("twitter") |> Elastex.run(conn)

      {:ok, %HTTPoison.Response{
        body: %{"_shards" => _shards,
                "indices" => _indices},
        status_code: status_code}} = resp

      assert status_code == 200
    end

  end

end

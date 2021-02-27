defmodule RocketpayWeb.UsersControllerTest do
  use RocketpayWeb.ConnCase, async: true

  describe "create_user/2" do
    test "when all params are valid, create an users", %{conn: conn} do
      params = %{
        "name" => "Marcos",
        "email" => "marcos@teste.com",
        "age" => "18",
        "nickname" => "marcos",
        "password" => "123456"
      }

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:created)

      assert %{
               "message" => "User created",
               "user" => %{
                 "account" => %{"balance" => "0.00", "id" => _account_id},
                 "id" => _id,
                 "name" => "Marcos",
                 "nickname" => "marcos"
               }
             } = response
    end

    test "when there are invalid params, return an error", %{conn: conn} do
      params = %{
        "name" => "Marcos",
        "email" => "marcos@teste.com",
        "age" => "17",
        "nickname" => "marcos",
        "password" => "12345"
      }

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:bad_request)

      expected_response = %{
        "message" => %{
          "age" => ["must be greater than or equal to 18"],
          "password" => ["should be at least 6 character(s)"]
        }
      }

      assert response == expected_response
    end
  end
end

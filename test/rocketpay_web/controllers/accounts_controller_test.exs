defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.{Account, User}

  describe "deposit/2" do
    setup %{conn: conn} do
      params = %{
        name: "Marcos",
        password: "123456",
        nickname: "marcosvcorsi",
        email: "marcos@teste.com.br",
        age: 18
      }

      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)

      conn = put_req_header(conn, "authorization", "Basic YmFuYW5hOm5hbmljYTEyMw==")

      {:ok, conn: conn, account_id: account_id}
    end

    test "when all params are valid, do the deposit", %{conn: conn, account_id: account_id} do
      params = %{"value" => "50.00"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:ok)

      assert %{
               "account" => %{
                 "account_id" => _id,
                 "balance" => "50.00"
               },
               "message" => "Balance changed successfully"
             } = response
    end

    test "when there are invalid params in deposit, return an error", %{
      conn: conn,
      account_id: account_id
    } do
      params = %{"value" => "invalid"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => "Invalid value!"}

      assert response == expected_response
    end
  end

  describe "withdraw/2" do
    setup %{conn: conn} do
      params = %{
        name: "Marcos",
        password: "123456",
        nickname: "marcosvcorsi",
        email: "marcos@teste.com.br",
        age: 18
      }

      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)

      conn = put_req_header(conn, "authorization", "Basic YmFuYW5hOm5hbmljYTEyMw==")

      deposit_params = %{
        "id" => account_id,
        "value" => "100.0"
      }

      {:ok, _data} = Rocketpay.deposit(deposit_params)

      {:ok, conn: conn, account_id: account_id}
    end

    test "when all params are valid, do the withdraw", %{conn: conn, account_id: account_id} do
      params = %{"value" => "50.00"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :withdraw, account_id, params))
        |> json_response(:ok)

      assert %{
               "account" => %{
                 "account_id" => _id,
                 "balance" => "50.00"
               },
               "message" => "Balance changed successfully"
             } = response
    end

    test "when there are invalid params in withdraw, return an error", %{
      conn: conn,
      account_id: account_id
    } do
      params = %{"value" => "invalid"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :withdraw, account_id, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => "Invalid value!"}

      assert response == expected_response
    end
  end

  describe "transaction/2" do
    setup %{conn: conn} do
      params = %{
        name: "Marcos",
        password: "123456",
        nickname: "marcosvcorsi",
        email: "marcos@teste.com.br",
        age: 18
      }

      params2 = %{
        name: "Marcos 2",
        password: "123456",
        nickname: "marcosvcorsi2",
        email: "marcos2@teste.com.br",
        age: 20
      }

      {:ok, %User{account: from_account}} = Rocketpay.create_user(params)

      {:ok, %User{account: to_account}} = Rocketpay.create_user(params2)

      conn = put_req_header(conn, "authorization", "Basic YmFuYW5hOm5hbmljYTEyMw==")

      deposit_params = %{
        "id" => from_account.id,
        "value" => "100.0"
      }

      {:ok, _data} = Rocketpay.deposit(deposit_params)

      {:ok, conn: conn, from_account: from_account, to_account: to_account}
    end

    test "when all params are valid, do the transaction", %{
      conn: conn,
      from_account: from_account,
      to_account: to_account
    } do
      params = %{
        "from" => from_account.id,
        "to" => to_account.id,
        "value" => "50.00"
      }

      response =
        conn
        |> post(Routes.accounts_path(conn, :transaction, params))
        |> json_response(:ok)

      expected_response = %{
        "message" => "Transaction done successfully",
        "trasaction" => %{
          "from_account" => %{
            "balance" => "50.00",
            "id" => from_account.id
          },
          "to_account" => %{"balance" => "50.00", "id" => to_account.id}
        }
      }

      assert response == expected_response
    end

    test "when there are params invalid, return an error", %{
      conn: conn,
      from_account: from_account,
      to_account: to_account
    } do
      params = %{
        "from" => from_account.id,
        "to" => to_account.id,
        "value" => "invalid"
      }

      response =
        conn
        |> post(Routes.accounts_path(conn, :transaction, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => "Invalid value!"}

      assert response == expected_response
    end
  end
end

defmodule RocketpayWeb.AccountsViewTest do
  use RocketpayWeb.ConnCase, async: true

  import Phoenix.View

  alias Rocketpay.User
  alias RocketpayWeb.AccountsView
  alias Rocketpay.Acccounts.Transactions.Response, as: TransactionResponse

  test "renders update.json" do
    params = %{
      name: "Marcos",
      password: "123456",
      nickname: "marcosvcorsi",
      email: "marcos@teste.com.br",
      age: 18
    }

    {:ok, %User{account: account}} = Rocketpay.create_user(params)

    response = render(AccountsView, "update.json", account: account)

    expected_response = %{
      account: %{
        account_id: account.id,
        balance: Decimal.new("0.00")
      },
      message: "Balance changed successfully"
    }

    assert expected_response == response
  end

  test "renders transaction.json" do
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

    transaction = %TransactionResponse{to_account: to_account, from_account: from_account}

    response = render(AccountsView, "transaction.json", transaction: transaction)

    expected_response = %{
      message: "Transaction done successfully",
      trasaction: %{
        from_account: %{
          balance: Decimal.new("0.00"),
          id: from_account.id
        },
        to_account: %{
          balance: Decimal.new("0.00"),
          id: to_account.id
        }
      }
    }

    assert expected_response == response
  end
end

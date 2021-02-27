defmodule Rocketpay.Users.CreateTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.User
  alias Rocketpay.Users.Create

  describe "call/1" do
    test "when all params are valid, returns an user" do
      params = %{
        name: "Marcos",
        password: "123456",
        nickname: "marcosvcorsi",
        email: "marcos@teste.com.br",
        age: 18
      }

      {:ok, %User{id: user_id}} = Create.call(params)

      user = Repo.get(User, user_id)

      assert %User{name: "Marcos", age: 18, id: ^user_id} = user
    end

    test "when there are invalid params are valid, returns an error" do
      params = %{
        name: "Marcos",
        nickname: "marcosvcorsi",
        email: "marcos@teste.com.br",
        age: 15
      }

      {:error, changeset} = Create.call(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["can't be blank"]
      }

      assert errors_on(changeset) == expected_response
    end
  end
end

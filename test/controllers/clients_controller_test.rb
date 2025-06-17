require "test_helper"

class ClientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @client = Client.create(name: "Test Client", email: "test@example.com")
  end

  test "should get index" do
    get clients_url
    assert_response :success
  end

  test "should get new" do
    get new_client_url
    assert_response :success
  end

  test "should show client" do
    get client_url(@client)
    assert_response :success
  end

  test "should get edit" do
    get edit_client_url(@client)
    assert_response :success
  end
end

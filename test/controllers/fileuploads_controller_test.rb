require 'test_helper'

class FileuploadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fileupload = fileuploads(:one)
  end

  test "should get index" do
    get fileuploads_url
    assert_response :success
  end

  test "should get new" do
    get new_fileupload_url
    assert_response :success
  end

  test "should create fileupload" do
    assert_difference('Fileupload.count') do
      post fileuploads_url, params: { fileupload: { filepath: @fileupload.filepath, name: @fileupload.name, thumbnail_img_path: @fileupload.thumbnail_img_path } }
    end

    assert_redirected_to fileupload_url(Fileupload.last)
  end

  test "should show fileupload" do
    get fileupload_url(@fileupload)
    assert_response :success
  end

  test "should get edit" do
    get edit_fileupload_url(@fileupload)
    assert_response :success
  end

  test "should update fileupload" do
    patch fileupload_url(@fileupload), params: { fileupload: { filepath: @fileupload.filepath, name: @fileupload.name, thumbnail_img_path: @fileupload.thumbnail_img_path } }
    assert_redirected_to fileupload_url(@fileupload)
  end

  test "should destroy fileupload" do
    assert_difference('Fileupload.count', -1) do
      delete fileupload_url(@fileupload)
    end

    assert_redirected_to fileuploads_url
  end
end

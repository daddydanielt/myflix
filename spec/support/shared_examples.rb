shared_examples "tokenable" do
  it "generate random token" do
    expect(token).to be_present
  end
end

shared_examples "requires sign in" do
  it "redirects to the signin_path" do
     clear_current_user
     action #pass in from the test case
     expect(response).to redirect_to(signin_path)
  end
  #it "redirects to the my_queues_path" do
  #end
end

shared_examples "requires admin" do
  it "redired non admin user to home_path" do
    non_admin_user = Fabricate(:user)
    set_current_user(non_admin_user)
    action
    expect(response).to redirect_to home_path
  end
  it "set flash[:error] for non admin user" do
    non_admin_user = Fabricate(:user)
    set_current_user(non_admin_user)
    action
    expect(flash[:error]).to be_present
  end
end
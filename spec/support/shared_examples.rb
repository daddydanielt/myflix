shared_examples "tokenable" do
  it "generates random token" do
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
  it "redirects nonadmin user to home_path" do
    non_admin_user = Fabricate(:user)
    set_current_user(non_admin_user)
    action
    expect(response).to redirect_to home_path
  end
  it "sets flash[:error] for non admin user" do
    non_admin_user = Fabricate(:user)
    set_current_user(non_admin_user)
    action
    expect(flash[:error]).to be_present
  end
end

shared_examples "send email after successfully sing up" do
  it "sends out the email" do
    ActionMailer::Base.deliveries.should_not be_empty
  end
  it "has the right content" do
    email = ActionMailer::Base.deliveries.last
    expect(email.body).to include(user_params[:full_name])
  end
  it "sends to the right recipient" do
    email = ActionMailer::Base.deliveries.last
    expect(email.to.first).to eq(user_params[:email])
  end
end
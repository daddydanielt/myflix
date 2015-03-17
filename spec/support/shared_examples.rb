 shared_examples "requires sign in" do   
   
   it "redirects to the signin_path" do
      clear_current_user
      action #pass in from the test case
      expect(response).to redirect_to(signin_path)
   end

   #it "redirects to the my_queues_path" do
   #end

 end
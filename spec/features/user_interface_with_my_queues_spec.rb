require 'spec_helper'

feature "User interacts with the queue" do

  given(:user_daniel) { Fabricate(:user) }
  given(:video_category_tv_commedies) { Fabricate(:category, title: "tv_commedies") }
  given(:video_monk) { Fabricate(:video, title: "Monk", category: video_category_tv_commedies) }
  given(:video_south_park) { Fabricate(:video, title: "South Park", category: video_category_tv_commedies) }
  given(:video_futurama) { Fabricate(:video, title: "Futurama", category: video_category_tv_commedies) }
  
  context "Refactory" do
    scenario "user adds videos in the queue and reorder the list_order" do    
      #sign_in    
      user_sign_in(user_daniel)
      
      #add videos into My Queues
      add_video_to_my_queues(video_monk)
      add_video_to_my_queues(video_south_park)
      add_video_to_my_queues(video_futurama)

      #reorder List Order
      set_video_list_order(video_monk,3)
      set_video_list_order(video_south_park,2)
      set_video_list_order(video_futurama,1)

      #verify
      #--->
      expect_video_to_be_added_into_my_queues(video_monk)
      expect_video_to_be_added_into_my_queues(video_south_park)
      expect_video_to_be_added_into_my_queues(video_futurama)
      #--->
      
      expect_video_list_order(video_monk,3)
      expect_video_list_order(video_south_park,2)
      expect_video_list_order(video_futurama,1)
      #--->
    end
  end # End context "Refactory"

  context "Original" do
    scenario "user adds videos in the queue and reorder the list_order - original" do    
      tv_commedies = Fabricate(:category, title: "tv_commedies")
      
      monk = Fabricate(:video, title: "Monk", category: tv_commedies)
      south_park = Fabricate(:video, title: "South Park", category: tv_commedies)
      futurama = Fabricate(:video, title: "Futurama", category: tv_commedies)

      user = Fabricate(:user)
      user_sign_in(user)    
      find("a[href='/videos/#{monk.id}']").click    
      page.should have_content(monk.title)

      click_link "+ My Queue"
      page.should have_content("My Queue")
      page.should have_content(monk.title)

      visit video_path(monk.id)
      page.should_not have_content "+ My Queue"

      #--->
      visit home_path
      find("a[href='/videos/#{south_park.id}']").click    
      click_link "+ My Queue"
      expect_video_to_be_added_into_my_queues south_park
      #--->
      
      #--->
      visit home_path
      find("a[href='/videos/#{futurama.id}']").click    
      click_link "+ My Queue"
      expect_video_to_be_added_into_my_queues futurama
      #--->

      #=======#
      visit my_queues_path    
      #save_and_open_page  
      #--->
      #[method-1]
      #fill_in("video_#{monk.id}", with: '3')
      #fill_in("video_#{south_park.id}", with: '2')
      #fill_in("video_#{futurama.id}", with: '1')
      #--->
      #[method-2](Capybara scoping technique)
      within(:xpath, "//tr[contains(.,'#{monk.title}')]") do      
        fill_in "my_queues[][list_order]", with: 3
      end
      within(:xpath, "//tr[contains(.,'#{south_park.title}')]") do      
        fill_in "my_queues[][list_order]", with: 2
      end
      within(:xpath, "//tr[contains(.,'#{futurama.title}')]") do      
        fill_in "my_queues[][list_order]", with: 1
      end
      #--->
      #[method-3] more organization
      # set_video_list_order( monk, 3)
      #--->
      #[method-4]
      #find("input[data-video-id='#{monk.id}']").set(3)
      #find("input[data-video-id='#{south_park.id}']").set(2)
      #find("input[data-video-id='#{futurama.id}']").set(1)
      #--->
      click_button "Update Instant Queue"
      #--->

      

      #--->
      #expect( find("#video_#{monk.id}").value.to_i ).to eq(3)
      #expect( find("#video_#{south_park.id}").value.to_i ).to eq(2)
      #expect( find("#video_#{futurama.id}").value.to_i ).to eq(1)
      #--->
      #--->
      #[method-1]
      expect( find(:xpath, "//tr[contains(.,'#{monk.title}')]//input[@type='text']").value.to_i ).to eq(3)
      #--->
      #[method-2]
      expect( find("input[data-video-id='#{monk.id}']").value.to_i ).to eq(3)
      #--->
      #[method-3] more organization
      expect_video_list_order( monk,3 )
      #--->
      expect( find("input[data-video-id='#{south_park.id}']").value.to_i ).to eq(2)
      expect( find("input[data-video-id='#{futurama.id}']").value.to_i ).to eq(1)
      #--->
    end
  end # End context "Original"

  #==================================================>>
  #[Helpers]
  def add_video_to_my_queues(video)
    visit home_path
    find("a[href='/videos/#{video.id}']").click    
    click_link "+ My Queue"
  end

  def set_video_list_order(video, list_order)
    visit my_queues_path
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do      
      fill_in "my_queues[][list_order]", with: list_order
    end
    click_button "Update Instant Queue"
  end

  def expect_video_to_be_added_into_my_queues(video)
    visit my_queues_path    
    page.should have_content(video.title)
    visit video_path(video.id)
    page.should_not have_content "+ My Queue"
  end

  def expect_video_list_order(video, list_order)
    visit my_queues_path
    expect( find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value.to_i ).to eq(list_order) 
  end
  #==================================================>>
end
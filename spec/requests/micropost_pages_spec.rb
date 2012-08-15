require 'spec_helper'

describe "MicropostPages" do

	subject {page}

	let(:user) {FactoryGirl.create(:user)}
	before {sign_in user}

	describe "micropost creation" do
		before {visit root_path}

		describe "with invalid information" do

			it "should not create a micropost" do
				expect {click_button "Post"}.should_not change(Micropost, :count)
			end

			describe "error messages" do
				before {click_button "Post"}
				it {should have_content('error')}
			end
		end

		describe "with valid information" do

			before {fill_in 'micropost_content', with: "Lorem ipsum"}
			it "should create a micropost" do
				expect {click_button "Post"}.should change(Micropost, :count).by(1)
			end
		end
	end

	describe "micropost destruction" do
		before {FactoryGirl.create(:micropost, user: user)}

		describe "as correct user" do
			before {visit root_path}

			it "should delete a micropost" do
				expect{click_link "delete"}.should change(Micropost, :count).by(-1)
			end
		end
	end

	describe "sidebar micropost count" do
		before {FactoryGirl.create(:micropost, user: user)}

		describe "single post" do
			before {visit root_path}
			it {should have_content("1 micropost")}
		end

		describe "more than 1 post" do
			before {FactoryGirl.create(:micropost, user: user, content: "foobar")}
			before {visit root_path}
			it {should have_content("2 microposts")}
		end
	end

	describe "user cannot delete different users posts" do
		before {FactoryGirl.create(:micropost, user: user)}
		let(:user2) {FactoryGirl.create(:user)}
		before {sign_in user2}
		before {visit user_path(user)}
		it {should_not have_link('delete')}
	end
end

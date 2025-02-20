require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  context "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:tweet) }
  end
end

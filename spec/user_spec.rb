require "spec_helper"

RSpec.describe User do
  let(:user) { described_class.new("Ben", 20) }
  context "initializer method" do
    it "works with two arguments" do
      expect(User).to respond_to(:new).with(2).arguments
    end
    it "expects user to be a working instance" do
      expect(user).to be_instance_of(User)
    end

    it "can access the name" do
      expect(user.name).to eq("Ben")
    end
  end

  describe ".create_table" do
    it "creates the users table" do
      User.create_table
      sql = "SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name='users';"
      expect(DB[:conn].execute(sql)[0]).to eq(["users"])
    end
  end

  describe ".drop_table" do
    it "drops the users table" do
      User.create_table
      User.drop_table
      sql = "SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name='users';"
      expect(DB[:conn].execute(sql)[0]).to eq(nil)
    end
  end

  describe "#save" do
    it "saves an instance of a User" do
      User.create_table
      user.save
      expect(user.id).to eq(1)
      expect(DB[:conn].execute("SELECT * FROM users")).to eq([[1, "Ben", 20]])
    end
  end

  describe ".create" do
    it "checks that our .create method correctly calls save" do
      User.create("Jim", 21)
      expect(DB[:conn].execute("SELECT * FROM users")).to eq([[1, "Ben", 20], [2, "Jim", 21]])
    end
  end
end

require 'rails_helper'

describe CustomQueue do
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
end

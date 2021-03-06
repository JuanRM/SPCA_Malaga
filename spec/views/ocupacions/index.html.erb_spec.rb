require 'spec_helper'

describe "ocupacions/index" do
  before(:each) do
    assign(:ocupacions, [
      stub_model(Ocupacion,
        :nombre => "Nombre"
      ),
      stub_model(Ocupacion,
        :nombre => "Nombre"
      )
    ])
  end

  it "renders a list of ocupacions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Nombre".to_s, :count => 2
  end
end

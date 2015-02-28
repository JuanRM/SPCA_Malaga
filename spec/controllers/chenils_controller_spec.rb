require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe ChenilsController do

  # This should return the minimal set of attributes required to create a valid
  # Chenil. As you add validations to Chenil, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end
  
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ChenilsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all chenils as @chenils" do
      chenil = Chenil.create! valid_attributes
      get :index, {}, valid_session
      assigns(:chenils).should eq([chenil])
    end
  end

  describe "GET show" do
    it "assigns the requested chenil as @chenil" do
      chenil = Chenil.create! valid_attributes
      get :show, {:id => chenil.to_param}, valid_session
      assigns(:chenil).should eq(chenil)
    end
  end

  describe "GET new" do
    it "assigns a new chenil as @chenil" do
      get :new, {}, valid_session
      assigns(:chenil).should be_a_new(Chenil)
    end
  end

  describe "GET edit" do
    it "assigns the requested chenil as @chenil" do
      chenil = Chenil.create! valid_attributes
      get :edit, {:id => chenil.to_param}, valid_session
      assigns(:chenil).should eq(chenil)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Chenil" do
        expect {
          post :create, {:chenil => valid_attributes}, valid_session
        }.to change(Chenil, :count).by(1)
      end

      it "assigns a newly created chenil as @chenil" do
        post :create, {:chenil => valid_attributes}, valid_session
        assigns(:chenil).should be_a(Chenil)
        assigns(:chenil).should be_persisted
      end

      it "redirects to the created chenil" do
        post :create, {:chenil => valid_attributes}, valid_session
        response.should redirect_to(Chenil.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved chenil as @chenil" do
        # Trigger the behavior that occurs when invalid params are submitted
        Chenil.any_instance.stub(:save).and_return(false)
        post :create, {:chenil => {}}, valid_session
        assigns(:chenil).should be_a_new(Chenil)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Chenil.any_instance.stub(:save).and_return(false)
        post :create, {:chenil => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested chenil" do
        chenil = Chenil.create! valid_attributes
        # Assuming there are no other chenils in the database, this
        # specifies that the Chenil created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Chenil.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => chenil.to_param, :chenil => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested chenil as @chenil" do
        chenil = Chenil.create! valid_attributes
        put :update, {:id => chenil.to_param, :chenil => valid_attributes}, valid_session
        assigns(:chenil).should eq(chenil)
      end

      it "redirects to the chenil" do
        chenil = Chenil.create! valid_attributes
        put :update, {:id => chenil.to_param, :chenil => valid_attributes}, valid_session
        response.should redirect_to(chenil)
      end
    end

    describe "with invalid params" do
      it "assigns the chenil as @chenil" do
        chenil = Chenil.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Chenil.any_instance.stub(:save).and_return(false)
        put :update, {:id => chenil.to_param, :chenil => {}}, valid_session
        assigns(:chenil).should eq(chenil)
      end

      it "re-renders the 'edit' template" do
        chenil = Chenil.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Chenil.any_instance.stub(:save).and_return(false)
        put :update, {:id => chenil.to_param, :chenil => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested chenil" do
      chenil = Chenil.create! valid_attributes
      expect {
        delete :destroy, {:id => chenil.to_param}, valid_session
      }.to change(Chenil, :count).by(-1)
    end

    it "redirects to the chenils list" do
      chenil = Chenil.create! valid_attributes
      delete :destroy, {:id => chenil.to_param}, valid_session
      response.should redirect_to(chenils_url)
    end
  end

end

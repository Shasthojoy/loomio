class API::SearchController < API::RestfulController

  def index
    @search = resource_class.search_for(params[:q], current_user, search_params)
    respond_with_collection serializer: SearchResultSerializer, root: :search_results
  end

  def notified
    @search = Queries::NotifiedSearch.new(params[:q], current_user).results
    respond_with_collection serializer: NotifiedResultSerializer, root: :notified_results
  end

  private

  def search_params
    params.slice(:from, :per).compact
  end

  def resource_class
    Discussion
  end

end

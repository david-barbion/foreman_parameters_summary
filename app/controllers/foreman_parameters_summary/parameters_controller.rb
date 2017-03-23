module ForemanParametersSummary
  class ParametersController < ::ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    
    before_filter :find_resource, :only => [:edit, :update, :destroy]

    def index
      @parameters = Parameter.select(:name).group(:name).search_for(params[:search], :order => params[:order]).paginate(:page => params[:page])
    end

    def show
       @name = params[:id]
       @selected_parameters = Parameter.joins("left join taxonomies on parameters.reference_id=taxonomies.id",
                                              "left join hosts on parameters.reference_id=hosts.id").
                                        select("parameters.value,
                                                parameters.type,
                                                  case 
                                                    when parameters.type = 'LocationParameter' or parameters.type = 'OrganizationParameter' then   taxonomies.title 
                                                    when parameters.type = 'HostParameter' then hosts.name 
                                                  end as place,
                                                parameters.priority"
                                        ).
                                        where(name: @name).
                                        reorder(params[:order])
                              .paginate(:page => params[:page])
    end

  end
end

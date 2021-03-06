class Api::V1::DownloadsController < Api::BaseController
  respond_to :json, :xml, :yaml

  def index
    respond_to do |format|
      format.any(:all) { render :text => Download.count }
      format.json { render :json => {:total => Download.count} }
      format.xml  { render :xml  => {:total => Download.count} }
      format.yaml { render :text => {:total => Download.count}.to_yaml }
    end
  end

  def show
    full_name = params[:id]
    if rubygem_name = Version.rubygem_name_for(full_name)
      respond_with(
        :total_downloads   => Download.for_rubygem(rubygem_name),
        :version_downloads => Download.for_version(full_name)
      )
    else
      render :text => "This rubygem could not be found.", :status => :not_found
    end
  end

  def top
    respond_with(
      :gems => Download.most_downloaded_today(50).map {|version, count|
        [version.attributes, count]
      }
    )
  end

end

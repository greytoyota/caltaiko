class VideosController < ApplicationController

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)

    if @video.save
      redirect_to @video
    else
      render 'new'
    end
  end

  def index
    @videos = Video.all.order('year DESC')
    @by_year = Hash.new
    @videos.each do |video|
      @by_year[video.year.to_s] ||= []
      @by_year[video.year.to_s] << video
    end
  end

  def show
    set_video
  end

  def edit
    set_video
  end

  def update
    set_video

    if @video.update(video_params)
      redirect_to @video
    else
      render 'edit'
    end
  end

  def destroy
    set_video
    @video.destroy

    redirect_to videos_path
  end

private
  def set_video
    @video = Video.friendly.find(params[:id])
  end

  def video_params
    params.require(:video).permit(:title, :link, :year)
  end
end
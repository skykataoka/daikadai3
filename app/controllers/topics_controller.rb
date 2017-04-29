class TopicsController < ApplicationController
before_action :authenticate_user!
  def index
    @topics = Topic.all
  end

  def show
    @topic = Topic.find(params[:id])
    @comment = @topic.comments.build  ##←当該トピックに関連する空のコメントインストールを作ってる。
    @comments = @topic.comments  ##←当該トピックに関連するすべてのコメントをインスタンス化
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(topics_params)
    @topic.user_id = current_user.id
    if @topic.save
      redirect_to topics_path, notice: "ブログを作成しました！"
      NoticeMailer.sendmail_topic(@topic).deliver
    else
      render 'new'
    end
  end

  def edit
    @topic = Topic.find(params[:id])
  end

  def update
    @topic = Topic.find(params[:id])
    @topic.update(topics_params)
    redirect_to topics_path
  end

  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy
    redirect_to topics_path ,notice: "ブログを削除しました！"
  end

  private
  def topics_params
    params.require(:topic).permit(:title, :content)
  end
end

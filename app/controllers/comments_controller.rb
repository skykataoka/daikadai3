class CommentsController < ApplicationController
  # コメントを保存、投稿するためのアクションです。
  def create
    # Topicをパラメータの値から探し出し,Topicに紐づくcommentsとしてbuildします。
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @topic = @comment.topic
    # クライアント要求に応じてフォーマットを変更
    respond_to do |format|
      if @comment.save
        format.html { redirect_to topic_path(@topic), notice: 'コメントを投稿しました。' }
        # JS形式でレスポンスを返します。
        format.js { render :index }
      else
        format.html { render :new }
      end
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    @topic = @comment.topic
      if @comment.update(comment_params)
        redirect_to topic_path(@topic), notice: 'コメントを更新しました。'
        else
        render :new
      end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      if @comment.destroy
        format.json { render :show, status: :created, location: @comment }
        #JS形式でレスポンスを返します。
        format.js { render :index }
        else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # ストロングパラメーター
    def comment_params
      params.require(:comment).permit(:topic_id, :content)
    end
end

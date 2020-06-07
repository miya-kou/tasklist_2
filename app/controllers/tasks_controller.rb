class TasksController < ApplicationController
    before_action :require_user_logged_in, only: [:index, :show]
  def index
    @tasks = Task.where(user_id: session[:user_id])
  end

  def show
    set_task
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = session[:user_id]
    if @task.save
      flash[:success] = 'タスクが投稿されました'
      redirect_to @task
    else
      flash[:danger] = 'タスクが投稿されません'
      render :new
    end
  end

  def edit
    set_task
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      flash[:success] = 'タスクが編集されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクが編集されませんでした'
      render :new
    end
  end

  def destroy
    set_task
    @task.destroy

    flash[:success] = 'タスクが削除されました'
    redirect_to tasks_path
  end
  
  private
  
  def set_task
    @task = Task.find(params[:id])
  end


  def task_params
    params.require(:task).permit(:content, :status)
  end
end

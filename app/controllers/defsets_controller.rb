class DefsetsController < ApplicationController
  before_filter :current_user_admin?
  before_action :set_defset, only: [:show, :edit, :update, :destroy]

  # GET /defsets
  # GET /defsets.json
  def index
    @defsets = Defset.all
  end

  # GET /defsets/1
  # GET /defsets/1.json
  def show
  end

  # GET /defsets/new
  def new
    @defset = Defset.new
  end

  # GET /defsets/1/edit
  def edit
  end

  # POST /defsets
  # POST /defsets.json
  def create
    @defset = Defset.new(defset_params)

    respond_to do |format|
      if @defset.save
        format.html { redirect_to @defset, notice: 'Defset was successfully created.' }
        format.json { render action: 'show', status: :created, location: @defset }
      else
        format.html { render action: 'new' }
        format.json { render json: @defset.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /defsets/1
  # PATCH/PUT /defsets/1.json
  def update
    respond_to do |format|
      if @defset.update(defset_params)
        format.html { redirect_to @defset, notice: 'Defset was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @defset.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /defsets/1
  # DELETE /defsets/1.json
  def destroy
    @defset.destroy
    respond_to do |format|
      format.html { redirect_to defsets_url }
      format.json { head :no_content }
    end
  end

  def new_taximeter
    @defset = Defset.find_by_name("taximeter")
    if @defset == nil
      @monetary_unit = Defset.find_by_name("денежная единица").value
      @defset = Defset.new
      @cost_km_city = 0
      @cost_km_suburb = 0
      @cost_km_intercity = 0
      @cost_km_n1 = 0
      @cost_stopping = 0
      @cost_passenger_boarding_day = 0
      @cost_passenger_boarding_night = 0
      @cost_passenger_pre_boarding_day = 0
      @cost_passenger_pre_boarding_night = 0
    else
      redirect_to edit_defset_taximeter_path, notice: 'Настройки по умолчанию для таксометра уже созданы.'
    end
  end

  def edit_taximeter
    @defset = Defset.find_by_name("taximeter")
    @cost_km_city = @defset.value["cost_km_city"]
    @cost_km_suburb = @defset.value["cost_km_suburb"]
    @cost_km_intercity = @defset.value["cost_km_intercity"]
    @cost_km_n1 = @defset.value["cost_km_n1"]
    @cost_stopping = @defset.value["cost_stopping"]
    @cost_passenger_boarding_day = @defset.value["cost_passenger_boarding_day"]
    @cost_passenger_boarding_night = @defset.value["cost_passenger_boarding_night"]
    @cost_passenger_pre_boarding_day = @defset.value["cost_passenger_pre_boarding_day"]
    @cost_passenger_pre_boarding_night = @defset.value["cost_passenger_pre_boarding_night"]
  end

  def create_taximeter
    taximeter = { 
                  "cost_km_city" => params[:cost_km_city],
                  "cost_km_suburb" => params[:cost_km_suburb],
                  "cost_km_intercity" => params[:cost_km_intercity],
                  "cost_km_n1" => params[:cost_km_n1],
                  "cost_stopping" => params[:cost_stopping],
                  "cost_passenger_boarding_day" => params[:cost_passenger_boarding_day],
                  "cost_passenger_boarding_night" => params[:cost_passenger_boarding_night],
                  "cost_passenger_pre_boarding_day" => params[:cost_passenger_pre_boarding_day],
                  "cost_passenger_pre_boarding_night" => params[:cost_passenger_pre_boarding_night]
                }
    @defset = Defset.new
    @defset.name = "taximeter"
    @defset.value = taximeter
    if @defset.save
      redirect_to showall_defsets_path, notice: 'Настройка таксометра создана успешено.'
    else
      flash[:notice] = "aaaaaaa"
      render action: 'new_taximeter' 
    end
  end

  def update_taximeter
    @defset = Defset.find_by_name("taximeter")
    if @defset != nil
      taximeter = { 
                    "cost_km_city" => params[:cost_km_city],
                    "cost_km_suburb" => params[:cost_km_suburb],
                    "cost_km_intercity" => params[:cost_km_intercity],
                    "cost_km_n1" => params[:cost_km_n1],
                    "cost_stopping" => params[:cost_stopping],
                    "cost_passenger_boarding_day" => params[:cost_passenger_boarding_day],
                    "cost_passenger_boarding_night" => params[:cost_passenger_boarding_night],
                    "cost_passenger_pre_boarding_day" => params[:cost_passenger_pre_boarding_day],
                    "cost_passenger_pre_boarding_night" => params[:cost_passenger_pre_boarding_night]
                  }
      @defset.name = "taximeter"
      @defset.value = taximeter
      if @defset.save
        redirect_to showall_defsets_path, notice: 'Настройки таксометра изменены успешно.'
      else
        render action: 'edit_taximeter' 
      end
    else
      redirect_to new_defset_taximeter_path
    end
  end

  def destroy_taximeter
    @defset = Defset.find_by_name("taximeter")
    @defset.destroy
    redirect_to showall_defsets_path, notice: "Настройки таксометра по умолчанию удалены"
  end

  def new_monetary_unit
    @defset = Defset.find_by_name("денежная единица")
    if @defset == nil
      @defset = Defset.new
    else
      redirect_to edit_defset_monetary_unit_path, notice: "Денежная единица по умолчанию уже создана"
    end
  end

  def edit_monetary_unit
    @defset = Defset.find_by_name("денежная единица")
    @name = @defset.name
    @value = @defset.value
  end

  def create_monetary_unit
    @defset = Defset.new
    @defset.name = params[:name]
    @defset.value = params[:value]
    if @defset.save
      redirect_to showall_defsets_path, notice: 'Настройка денежной единицы создана успешено.'
    else
      flash[:notice] = "денежную единицу создать не удалось"
      render action: 'new_taximeter' 
    end
  end

  def update_monetary_unit
    @defset = Defset.find_by_name("денежная единица")
    if @defset != nil
      @defset.name = params[:name]
      @defset.value = params[:value]
      if @defset.save
        redirect_to showall_defsets_path, notice: 'Настройки денежной единицы изменены успешно.'
      else
        flash[:notice] = "денежную единицу обновить не удалось"
        render action: 'edit_monetary_unit' 
      end
    else
      redirect_to new_defset_monetary_unit_path
    end
  end

  def destroy_monetary_unit
    @defset = Defset.find_by_name("денежная единица")
    @defset.destroy
    redirect_to showall_defsets_path, notice: "Настройки денежной единицы по умолчанию удалены"
  end

  def new_credit_policy
    @defset = Defset.find_by_name("кредитная политика постоянный водитель")
    if @defset == nil
    else
      redirect_to edit_defset_credit_policy_path, notice: 'Настройка кредитной политики уже существует.'
    end
  end

  def create_credit_policy
    @defset = Defset.find_by_name("кредитная политика постоянный водитель")
    if @defset == nil
      @defset = Defset.new
      @defset.name = params[:name]
      @defset.value = { "method" => params[:method], "cost" => params[:cost] }
      if @defset.save
        redirect_to showall_defsets_path, notice: 'Настройка кредитной политики создана успешено.'
      else
        redirect_to showall_defsets_path, notice: 'Настройка кредитной политики создана НЕ удалась.'
      end
    else
      redirect_to edit_defset_credit_policy_path, notice: 'Настройка кредитной политики уже существует.'
    end
  end

  def edit_credit_policy
    @defset = Defset.find_by_name("кредитная политика постоянный водитель")
    @name = @defset.name
    @method = @defset.value["method"]
    @cost = @defset.value["cost"]
  end

  def update_credit_policy
    @defset = Defset.find_by_name("кредитная политика постоянный водитель")
    if @defset != nil
      @defset.name = params[:name]
      @defset.value = { "method" => params[:method], "cost" => params[:cost] }
      if @defset.save
        redirect_to showall_defsets_path, notice: 'Настройки кредитной политики изменены успешно.'
      else
        flash[:notice] = "кредитную политику обновить не удалось"
        render action: 'edit_credit_policy' 
      end
    else
      redirect_to new_defset_monetary_unit_path
    end
  end

  def destroy_credit_policy
    @defset = Defset.find_by_name("кредитная политика постоянный водитель")
    @defset.destroy
    redirect_to showall_defsets_path, notice: "Настройки кредитной политики по умолчанию удалены"
  end

  def new_time_dec_score_regdrv
    @defset = Defset.find_by_name("время снятия средств со счёта для регулярного водителя")
    if @defset == nil
    else
      flash[:attn] = 'Настройка <strong>время снятия средств со счёта для регулярного водителя</strong> уже существует'.html_safe
      redirect_to edit_defset_time_dec_score_regdrv_path
    end
  end

  def create_time_dec_score_regdrv
    @defset = Defset.find_by_name("время снятия средств со счёта для регулярного водителя")
    if @defset == nil
      @defset = Defset.new
      @defset.name = params[:name]
      @defset.value = params[:value]
      if @defset.save
        flash[:notice] = 'Настройка <strong>время снятия средств со счёта для регулярного водителя</strong> создана успешено'.html_safe
        redirect_to showall_defsets_path
      else
        flash[:error] = 'Создание настройки "время снятия средств со счёта для регулярного водителя" НЕ удалась.'
        redirect_to showall_defsets_path
      end
    else
      flash[:error] = 'Настройка "время снятия средств со счёта для регулярного водителя" уже существует.'
      redirect_to showall_defsets_path
    end
  end

  def edit_time_dec_score_regdrv
    @defset = Defset.find_by_name("время снятия средств со счёта для регулярного водителя")
  end

  def update_time_dec_score_regdrv
    @defset = Defset.find_by_name("время снятия средств со счёта для регулярного водителя")
    if @defset != nil
      @defset.name = params[:name]
      @defset.value = params[:value]
      if @defset.save
        flash[:notice] = 'Настройка <strong>время снятия средств со счёта для регулярного водителя</strong> изменена успешено'.html_safe
        redirect_to showall_defsets_path
      else
        flash[:error] = 'Изменение настройки "время снятия средств со счёта для регулярного водителя" НЕ удалась.'
        redirect_to showall_defsets_path
      end
    else
      flash[:error] = 'Настройка "время снятия средств со счёта для регулярного водителя" НЕ существует.'
      redirect_to showall_defsets_path
    end
  end

  def destroy_time_dec_score_regdrv
    @defset = Defset.find_by_name("время снятия средств со счёта для регулярного водителя")
    @defset.destroy
    flash[:notice] = 'Настройка <strong>время снятия средств со счёта для регулярного водителя</strong> удалена успешено'.html_safe
    redirect_to showall_defsets_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_defset
      @defset = Defset.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def defset_params
      params.require(:defset).permit(:name, :value)
    end
end

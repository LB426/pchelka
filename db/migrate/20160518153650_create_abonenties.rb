class CreateAbonenties < ActiveRecord::Migration
  def change
    create_table :abonenties do |t|
      t.integer :num
      t.string :telefon
      t.string :kode
      t.string :adres
      t.date :dat
      t.time :tim
      t.integer :cost
      t.integer :balans
      t.integer :poezdok
      t.integer :otlog
      t.integer :priz
      t.string :fio
      t.string :telefon2
      t.date :first_d
      t.time :first_t
      t.integer :first_c    
      t.string :first_p    
      t.string :first_a    
      t.date :second_d   
      t.time :second_t   
      t.integer :second_c   
      t.string :second_p   
      t.string :second_a   
      t.date :third_d    
      t.time :third_t    
      t.integer :third_c    
      t.string :third_p    
      t.string :third_a    
      t.date :fourth_d   
      t.time :fourth_t   
      t.integer :fourth_c   
      t.string :fourth_p   
      t.string :fourth_a   
      t.date :fifth_d    
      t.time :fifth_t    
      t.integer :fifth_c    
      t.string :fifth_p    
      t.string :fifth_a    
      t.date :sixth_d    
      t.time :sixth_t    
      t.integer :sixth_c    
      t.string :sixth_p    
      t.string :sixth_a    
      t.date :seventh_d  
      t.time :seventh_t  
      t.integer :seventh_c  
      t.string :seventh_p  
      t.string :seventh_a  
      t.integer :num_f      
      t.date :eigth_d    
      t.time :eigth_t    
      t.integer :eigth_c    
      t.string :eigth_p    
      t.string :eigth_a    
      t.string :nineth_a   
      t.string :nineth_p   
      t.integer :nineth_c   
      t.time :nineth_t   
      t.date :nineth_d   
      t.date :tenth_d    
      t.time :tenth_t    
      t.integer :tenth_c    
      t.string :tenth_p    
      t.string :tenth_a    
      t.string :eleventh_a 
      t.string :eleventh_p 
      t.integer :eleventh_c 
      t.time :eleventh_t 
      t.date :eleventh_d 
      t.integer :first_m    
      t.integer :second_m   
      t.integer :third_m    
      t.integer :fourth_m   
      t.integer :fifth_m    
      t.integer :sixth_m    
      t.integer :seventh_m  
      t.integer :eigth_m    
      t.integer :nineth_m   
      t.integer :tenth_m    
      t.integer :eleventh_m 
      t.date :d_12       
      t.time :t_12       
      t.integer :c_12       
      t.string :p_12       
      t.string :a_12       
      t.integer :m_12       
      t.date :d_13       
      t.time :t_13       
      t.integer :c_13       
      t.string :p_13       
      t.string :a_13       
      t.integer :m_13       
      t.date :d_14       
      t.time :t_14       
      t.integer :c_14       
      t.string :p_14       
      t.string :a_14       
      t.integer :m_14       
      t.date :d_15       
      t.time :t_15       
      t.integer :c_15       
      t.string :p_15       
      t.string :a_15       
      t.integer :m_15       
      t.date :d_16       
      t.time :t_16       
      t.integer :c_16       
      t.string :p_16       
      t.string :a_16       
      t.integer :m_16       
      t.integer :vip        

      t.timestamps null: false
    end
  end
end

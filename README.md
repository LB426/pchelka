Цель проекта - управление небольшой службой такси.
Части проекта:
1) Диспетчерская: приём заказов, передача их водителям.
2) Таксометр: обработка заказа водителем.
3) Сервер: обмен информацией диспетчерская - водитель, запись треков машины.

отправить post через curl:
curl --data "param1=120&param2=word" http://127.0.0.1:3000/api/login/password/orderdestroy

Для развёртывание приложения на сервере:
1) настройка БД
rake db:drop
rake db:create
rake db:migrate
rake db:seed

Для работы со старой диспетчерской программой нужно иметь кодировку CP1251 для некоторых таблиц,
делаем так на пустой базе:
mysql
use databasename;
alter table zvonkis CONVERT TO CHARACTER SET cp1251 COLLATE cp1251_general_ci;
alter table abonenties CONVERT TO CHARACTER SET cp1251 COLLATE cp1251_general_ci;
alter table zakazis CONVERT TO CHARACTER SET cp1251 COLLATE cp1251_general_ci;

2) Создание админского пользователя:
rails console
User.create("login" => "admin", "password" => "1234", "group" => "admin,dispatcher,driver",      "car" => 10001, "cardesc" => "красн Вольво")
User.create("login" => "disp1", "password" => "1234", "group" => "dispatcher,driver", "car" => 10002, "cardesc" => "белый Вольво")
exit
В поле group перечисляются роли доступные пользователю.
Если администратор то group должен быть "admin,dispatcher,driver", т.е. он умеет всё что админ + диспетчер + водитель
Если диспетчер то group должен быть "dispatcher,driver", т.е. он умеет всё что диспетчер + водитель
Если водитель то ему доступны действия только для водителя.

Проверка работоспособности диспетчерской программы:


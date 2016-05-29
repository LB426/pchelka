# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Defset.create(name: "район вне зоны",
              value: nil )

Defset.create(name: "район Черёмушки",
              value: [
                       [ '40.11376619', '45.87505586' ],
                       [ '40.13078213', '45.88997829' ],
                       [ '40.17035007', '45.84646948' ],
                       [ '40.15625238', '45.84451138' ]])

Defset.create(name: "район Центр",
              value: [
                       [ '40.11403978', '45.87475333' ],
                       [ '40.15619338', '45.84464965' ],
                       [ '40.13110399', '45.83910009' ],
                       [ '40.08969069', '45.87000612' ],
                       [ '40.10471106', '45.87759549' ]])

Defset.create(name: "район Та сторона",
              value: [
                       [ '40.08357525', '45.87324816' ],
                       [ '40.06074429', '45.85465987' ],
                       [ '40.14056683', '45.80771321' ],
                       [ '40.14794827', '45.81249940' ],
                       [ '40.12803555', '45.83983259' ],
                       [ '40.08460522', '45.87265056' ]])

Defset.create(name: "район Парковый",
              value: [
                       [ '40.13069630', '45.83983259' ],
                       [ '40.16880512', '45.84569223' ],
                       [ '40.18022060', '45.83355372' ],
                       [ '40.14073849', '45.82536023' ]])

Defset.create(name: "денежная единица", value: "руб")

Defset.create(name: "taximeter",
              value: {
                        "cost_km_city" => 10,
                        "cost_km_suburb" => 11,
                        "cost_km_intercity" => 12,
                        "cost_km_n1" => 13,
                        "cost_stopping" => 5,
                        "cost_passenger_boarding_day" => 30,
                        "cost_passenger_boarding_night" => 40,
                        "cost_passenger_pre_boarding_day" => 50,
                        "cost_passenger_pre_boarding_night" => 60
                      })

Defset.create(name: "количество призовых поездок", value: 8)

Defset.create(name: "кредитная политика постоянный водитель",
              value: { "method" => "one_per_24_hours", "cost" => 150 })

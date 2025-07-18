﻿&НаКлиенте
Процедура Добавить1(Команда)
	КоличествоБракованнойПродукции = КоличествоБракованнойПродукции + 1;
КонецПроцедуры

&НаСервере
Процедура СохранитьПодсчетНаСервере()
	НовыйПодсчет = Справочники.Подсчеты.СоздатьЭлемент();
	НовыйПодсчет.КонтролерКачества = ПараметрыСеанса.ТекущийПользователь;
	НовыйПодсчет.КоличествоБракованнойПродукции = КоличествоБракованнойПродукции;
	НовыйПодсчет.Наименование = ПараметрыСеанса.ТекущийПользователь;
	НовыйПодсчет.Записать();
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПодсчет(Команда)
	СохранитьПодсчетНаСервере(); 
	
	Если ОтправитьДанныеНаСервер() Тогда
		Предупреждение("Подсчет сохранен и отправлен");
	Иначе
		Предупреждение("Достижения сохранены, но не отправлены");
	КонецЕсли;

	Закрыть();
КонецПроцедуры


&НаСервере
Функция ОтправитьДанныеНаСервер()
	
	//Записываем наши данные в структуру для отправки на сервер
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("Наименование", ПараметрыСеанса.ТекущийПользователь);
	СтруктураДанных.Вставить("КонтролерКачества", ПараметрыСеанса.ТекущийПользователь);
	СтруктураДанных.Вставить("КоличествоБракованнойПродукции", КоличествоБракованнойПродукции);
	
	//Создаем новую переменную для записи информации в JSON
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	
	//Записываем нашу структуру в JSON
	ЗаписатьJSON(ЗаписьJSON, СтруктураДанных);
	
	//Получаем закодированные данные строкой
	ДанныеСтрокой = ЗаписьJSON.Закрыть();
	
	//Добавляем попытку отправки данных на сервер
	Попытка
		//Подключаемся к нашему серверу
		//Тут указываем IP нашего компьютера
		//Для примера указывается 127.0.0.1
		HTTPСоединение = Новый HTTPСоединение("192.168.1.95"); 
		//Пишем запрос для отправки данных
		//Указываем тут наш сервер Exchange и его метод
		//Также передаем наши данные строкой в виде параметра ?SendCount=""
		HTTPЗапрос = Новый HTTPЗапрос("Exchange/hs/Exchange?SendCount=" + ДанныеСтрокой);
		//Отправляем наши данные на сервер и получаем ответ
		Ответ = HTTPСоединение.Получить(HTTPЗапрос);
		//Раз мы дошли до этого места, значит, система отправила данные
		//Поэтому возвращаем истину
		Возврат Истина;
		
	Исключение
	КонецПопытки;
	
	//Если данные не удалось отправить, возвращаем ложь
	Возврат Ложь;
КонецФункции
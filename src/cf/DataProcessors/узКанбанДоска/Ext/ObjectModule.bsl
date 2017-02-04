﻿#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьЗадачи() Экспорт
	пНастройкиКомпоновщика = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);	
	
	ТЗЗадачи = ПолучитьТЗЗадачи(пНастройкиКомпоновщика);
	Для каждого СтрокаТЗЗадачи из ТЗЗадачи цикл
		СтрокаТЗЗадачи.ОсновнаяЗадачаПредставление = СокрЛП(СтрокаТЗЗадачи.ОсновнаяЗадачаПредставление);		
	Конеццикла;
	ТЧЗадачи.Загрузить(ТЗЗадачи);
КонецПроцедуры 

Функция ПолучитьТЗЗадачи(НастройкиКомпоновщика) Экспорт 
	ТЗЗадачи = Новый ТаблицаЗначений;
	СхемаКомпоновкиДанныхКонсоли = ПолучитьМакет("СхемаКомпоновкиДанных");
	
	ИсполняемыеНастройки = НастройкиКомпоновщика;
	
	СписокВыбранныхСтатусов = Новый СписокЗначений;
	Для каждого СтрокаТЧНастройкиКолонок из ТЧНастройкиКолонок цикл
		Если НЕ СтрокаТЧНастройкиКолонок.Видимость Тогда
			Продолжить;
		Конецесли;
		СписокВыбранныхСтатусов.Добавить(СтрокаТЧНастройкиКолонок.Статус);		
	Конеццикла;

	ЗначениеПараметра = ИсполняемыеНастройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Наблюдатель"));
	Если ЗначениеПараметра <> Неопределено Тогда
		ЗначениеПараметра.Использование = Истина;
		ЗначениеПараметра.Значение = Наблюдатель;
	Конецесли;	
	
	ЗначениеПараметра = ИсполняемыеНастройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ИспользоватьОтборПоНаблюдателю"));
	Если ЗначениеПараметра <> Неопределено Тогда
		ЗначениеПараметра.Значение = ЗначениеЗаполнено(Наблюдатель);
		ЗначениеПараметра.Использование=Истина;	
	Конецесли;
	
	МассивВыбранныхСтатусовКолонок = Новый Массив();
	Для каждого СтрокаТЧНастройкиКолонок из ТЧНастройкиКолонок цикл
		Если НЕ СтрокаТЧНастройкиКолонок.Видимость Тогда
			Продолжить;
		Конецесли;
		МассивВыбранныхСтатусовКолонок.Добавить(СтрокаТЧНастройкиКолонок.Статус);
	Конеццикла;
	
	ЗначениеПараметра = ИсполняемыеНастройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("МассивВыбранныхСтатусовКолонок"));
	Если ЗначениеПараметра <> Неопределено Тогда
		ЗначениеПараметра.Значение = МассивВыбранныхСтатусовКолонок;
		ЗначениеПараметра.Использование=Истина;	
	Конецесли;	
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанныхКонсоли, ИсполняемыеНастройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);
	ПроцессорВывода.УстановитьОбъект(ТЗЗадачи);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);	
	
	Возврат ТЗЗадачи;
КонецФункции 

Процедура СменитьСтатусЗадачи(ДопПараметры) Экспорт
	НовыйСтатус = ДопПараметры.НовыйСтатус;
	МассивЗадач = ДопПараметры.МассивЗадач;
	
	Для каждого ЭлМассиваЗадач из МассивЗадач цикл
		СпрОбъект = ЭлМассиваЗадач.ПолучитьОбъект();		
		СпрОбъект.Статус = НовыйСтатус;
		СпрОбъект.Записать();
	Конеццикла;	
	ЗаполнитьЗадачи();
КонецПроцедуры 

Процедура ЗаполнитьТЧНастройкиКолонок()Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	узСтатусыЗадачи.Ссылка КАК Статус,
	|	узСтатусыЗадачи.ВидимостьПоУмолчанию КАК Видимость,
	|	узСтатусыЗадачи.ИмяПредопределенныхДанных
	|ИЗ
	|	Справочник.узСтатусыЗадачи КАК узСтатусыЗадачи
	|ГДЕ
	|	узСтатусыЗадачи.Предопределенный	
	|
	|УПОРЯДОЧИТЬ ПО
	|	узСтатусыЗадачи.РеквизитДопУпорядочивания";
	
	ТЧНастройкиКолонок.Загрузить(Запрос.Выполнить().Выгрузить());
КонецПроцедуры 

#КонецОбласти



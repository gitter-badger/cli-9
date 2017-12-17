Процедура ПриЗагрузкеБиблиотеки(Путь, СтандартнаяОбработка, Отказ)
	
	СтандартнаяОбработка = Ложь;
	
	ОбработатьСтруктуруКаталоговПоСоглашению(Путь, СтандартнаяОбработка, Отказ);
	
КонецПроцедуры

Процедура ОбработатьСтруктуруКаталоговПоСоглашению(Путь, СтандартнаяОбработка, Отказ)

	КаталогиКлассов = Новый Массив;
	КаталогиКлассов.Добавить(ОбъединитьПути(Путь, "Классы"));
	КаталогиКлассов.Добавить(ОбъединитьПути(Путь, "Classes"));
	КаталогиКлассов.Добавить(ОбъединитьПути(Путь, "src", "Классы"));
	КаталогиКлассов.Добавить(ОбъединитьПути(Путь, "src", "Classes"));

	КаталогиМодулей = Новый Массив;
	КаталогиМодулей.Добавить(ОбъединитьПути(Путь, "Модули"));
	КаталогиМодулей.Добавить(ОбъединитьПути(Путь, "Modules"));
	КаталогиМодулей.Добавить(ОбъединитьПути(Путь, "src", "Модули"));
	КаталогиМодулей.Добавить(ОбъединитьПути(Путь, "src", "Modules"));


	Для Каждого мКаталог Из КаталогиКлассов Цикл

		ОбработатьКаталогКлассов(мКаталог, СтандартнаяОбработка, Отказ);

	КонецЦикла;

	Для Каждого мКаталог Из КаталогиМодулей Цикл

		ОбработатьКаталогМодулей(мКаталог, СтандартнаяОбработка, Отказ);

	КонецЦикла;

КонецПроцедуры

Процедура ОбработатьКаталогКлассов(Знач Путь, СтандартнаяОбработка, Отказ)

	КаталогКлассов = Новый Файл(Путь);

	Если КаталогКлассов.Существует() Тогда
		Файлы = НайтиФайлы(КаталогКлассов.ПолноеИмя, "*.os", Истина);
		Для Каждого Файл Из Файлы Цикл
			СтандартнаяОбработка = Ложь;
			ДобавитьКласс(Файл.ПолноеИмя, Файл.ИмяБезРасширения);
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработатьКаталогМодулей(Знач Путь, СтандартнаяОбработка, Отказ)

	КаталогМодулей = Новый Файл(Путь);

	Если КаталогМодулей.Существует() Тогда
		Файлы = НайтиФайлы(КаталогМодулей.ПолноеИмя, "*.os", Истина);
		Для Каждого Файл Из Файлы Цикл
			СтандартнаяОбработка = Ложь;
			ДобавитьМодуль(Файл.ПолноеИмя, Файл.ИмяБезРасширения);
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры
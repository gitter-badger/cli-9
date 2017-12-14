//#Использовать "../"

Перем ИнициализацияГит;
Перем ПутьКПапкеГенерации;
Перем ИспользоватьПодкоманды;
Перем ИнтерактивныйРежим;
Перем ФайлКонфига;
Перем НаименованиеПриложения;

Перем Лог;

Перем ИмяФайлаСпецификацииПакета;

Процедура ОписаниеКоманды(Команда) Экспорт
	
	ИнициализацияГит = Команда.Опция("g git-init", Ложь, "инциализировать создание git репозитория").Флаговый();
	ИнтерактивныйРежим = Команда.Опция("interactive", Ложь, "интерактивный режим ввода информации о приложении").Флаговый();
	ИспользоватьПодкоманды = Команда.Опция("s support-subcommads", Ложь, "шаблон с поддержкой подкомманд").Флаговый();
	ФайлКонфига = Команда.Опция("c config-file", "", "файл настроек генерации приложения");
	
	НаименованиеПриложения = Команда.Аргумент("NAME", "", "наименование приложения");
	ПутьКПапкеГенерации = Команда.Аргумент("PATH", "", "Путь к папке для генерации нового приложения (по умолчанию рабочая папка)").ПоУмолчанию("./");
	
	Команда.Спек ="[-g] [-s] [(--interactive | (--config-file | -c ) )] PATH";

КонецПроцедуры

Процедура ВыполнитьКоманду(Знач Команда) Экспорт

	КаталогГенерацииПриложения = Новый Файл (ПутьКПапкеГенерации.Значение);
	Если НЕ КаталогГенерацииПриложения.Существует() Тогда
		СоздатьКаталог(КаталогГенерацииПриложения.ПолноеИмя);
	КонецЕсли;

	Если ПустаяСтрока(НаименованиеПриложения.Значение) Тогда
		НаименованиеПриложения = КаталогГенерацииПриложения.Имя;
	КонецЕсли;

	ОписаниеПриложения = Новый Структура;
	ОписаниеПриложения.Вставить("НаименованиеПриложения",НаименованиеПриложения);
	ОписаниеПриложения.Вставить("ОписаниеПриложения","Это приложение создано с помощью 1cli. И выполняет много полезной работы");

	ПодготовитьКаталогПроекта(КаталогГенерацииПриложения.ПолноеИмя, ОписаниеПриложения);
	ЗаписатьЗаготовкуЗагрузкиБиблиотеки(КаталогГенерацииПриложения.ПолноеИмя);
	ПодготовитьИсполняемыйКаталог(ОбъединитьПути(КаталогГенерацииПриложения.ПолноеИмя, "src", "cmd"), ОписаниеПриложения);

	Лог.Информация("Готово");

КонецПроцедуры 

Процедура ПодготовитьКаталогПроекта(Знач ВыходнойКаталог, ОписаниеПриложения) Экспорт
	
	Если ВыходнойКаталог = Неопределено Тогда
		ВыходнойКаталог = ТекущийКаталог();
	КонецЕсли;

	ИмяПакета = ОписаниеПриложения.НаименованиеПриложения;

	ВыходнойКаталог = Новый Файл(ВыходнойКаталог);
	
	Если Не ВыходнойКаталог.Существует() Тогда
		Лог.Информация("Создаю каталог " + ИмяПакета);
		СоздатьКаталог(ВыходнойКаталог.ПолноеИмя);
	Иначе
		Содержимое = НайтиФайлы(ВыходнойКаталог.ПолноеИмя, ПолучитьМаскуВсеФайлы());
		Если Содержимое.Количество() Тогда
			ВызватьИсключение "Каталог проекта " + ВыходнойКаталог.ПолноеИмя + " уже содержит файлы!";
		КонецЕсли;
	КонецЕсли;
	
	СоздатьПодкаталог(ВыходнойКаталог.ПолноеИмя, "src");
	СоздатьПодкаталог(ОбъединитьПути(ВыходнойКаталог.ПолноеИмя, "src"), "core");
	СоздатьПодкаталог(ОбъединитьПути(ВыходнойКаталог.ПолноеИмя, "src"), "cmd");
	СоздатьПодкаталог(ОбъединитьПути(ВыходнойКаталог.ПолноеИмя, "src", "cmd"), "Классы");
	СоздатьПодкаталог(ОбъединитьПути(ВыходнойКаталог.ПолноеИмя, "src", "cmd"), "Модули");
	СоздатьПодкаталог(ВыходнойКаталог.ПолноеИмя, "tasks");
	СоздатьПодкаталог(ВыходнойКаталог.ПолноеИмя, "tests");
	СоздатьПодкаталог(ВыходнойКаталог.ПолноеИмя, "docs");
	
	ЗаписатьЗаготовкуМанифестаБиблиотеки(ВыходнойКаталог.ПолноеИмя, ИмяПакета);
	
КонецПроцедуры

Процедура СоздатьПодкаталог(Знач База, Знач Имя)
	Лог.Информация("Создаю каталог " + Имя);
	СоздатьКаталог(ОбъединитьПути(База, Имя));
КонецПроцедуры

Процедура ЗаписатьЗаготовкуМанифестаБиблиотеки(Знач Каталог, Знач ИмяПакета)
	
	Лог.Информация("Создаю заготовку описания пакета");
	
	ЗаписьТекста = Новый ЗаписьТекста(ОбъединитьПути(Каталог, ИмяФайлаСпецификацииПакета));
	
	ЗаписьТекста.ЗаписатьСтроку("////////////////////////////////////////////////////////////");
	ЗаписьТекста.ЗаписатьСтроку("// Описание пакета для сборки и установки");
	ЗаписьТекста.ЗаписатьСтроку("// Полную документацию см. на hub.oscript.io/packaging");
	ЗаписьТекста.ЗаписатьСтроку("//");
	ЗаписьТекста.ЗаписатьСтроку("");
	
	Консоль = Новый Консоль;
	ДобавлятьПроцедурыПереопределения = Неопределено;
	
	Если ИнтерактивныйРежим.Значение Тогда
		
		Лог.Информация("Добавить в описание пакета процедуры переопределения сборки и установки?");
		
		Пока Истина Цикл
			Лог.Информация("(y/n)");
			Значение = Консоль.ПрочитатьСтроку();
			Если ВРег(Значение) = "Y" Тогда
				ДобавлятьПроцедурыПереопределения = Истина;
				Прервать;
			ИначеЕсли ВРег(Значение) = "N" Тогда
				ДобавлятьПроцедурыПереопределения = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	Иначе 
		ДобавлятьПроцедурыПереопределения = Истина;
	КонецЕсли;


	Если ДобавлятьПроцедурыПереопределения Тогда
		ЗаписатьЗаготовкуСкриптаУстановки(ЗаписьТекста);
		ЗаписатьЗаготовкуСкриптаСборки(ЗаписьТекста);
	КонецЕсли;

	ЗаписьТекста.ЗаписатьСтроку("
	|Описание.Имя(""" + ИмяПакета + """)
	|        .Версия(""0.0.1"")
	|        .Автор("""")
	|        .АдресАвтора(""author@somemail.com"")
	|        .Описание(""Это приложение создано с помощью 1cli. И выполняем много полезной работы"")
	|        .ВерсияСреды(""1.0.11"")
	|        .ИсполняемыйФайл(""src/cmd/"""+ИмяПакета+".os);"" 
	|        .ВключитьФайл(""src"")
	|        .ВключитьФайл(""doc"")
	|        .ВключитьФайл(""tests"")");

	Если ДобавлятьПроцедурыПереопределения Тогда
		ЗаписьТекста.ЗаписатьСтроку(
		"        .ВключитьФайл(""" + ИмяФайлаСпецификацииПакета + """)");
	КонецЕсли;
	
	ЗаписьТекста.ЗаписатьСтроку(
	"        .ЗависитОт(""logos"")
	|        .ЗависитОт(""1cli"")
	|        //.ЗависитОт(""package3"", "">=1.1"", ""<2.0"")
	|        //.ЗависитОт(""package4"", "">=1.1"", ""<2.0"")
	|        //.ОпределяетКласс(""УправлениеВселенной"", ""src/universe-mngr.os"")
	|        //.ОпределяетМодуль(""ПолезныеФункции"", ""src/tools.os"")
	|        ;");
	
	ЗаписьТекста.Закрыть();
	
КонецПроцедуры

Процедура ЗаписатьЗаготовкуСкриптаУстановки(ЗаписьТекста)
	
	Лог.Информация("Создаю процедур установки/удаления");

	ЗаписьТекста.ЗаписатьСтроку("///////////////////////////////////////////////////////////////////");
	ЗаписьТекста.ЗаписатьСтроку("// Процедуры установки пакета с клиентской машины        ");
	ЗаписьТекста.ЗаписатьСтроку("///////////////////////////////////////////////////////////////////
	|
	|");
		
	ЗаписьТекста.ЗаписатьСтроку("// Вызывается пакетным менеджером после распаковки пакета на клиентскую машину.");
	ЗаписьТекста.ЗаписатьСтроку("// ");
	ЗаписьТекста.ЗаписатьСтроку("// Параметры:");
	ЗаписьТекста.ЗаписатьСтроку("//   КаталогУстановкиПакета - строка. Путь в который пакетный менеджер устанавливает текущий пакет.");
	ЗаписьТекста.ЗаписатьСтроку("// ");
	ЗаписьТекста.ЗаписатьСтроку("Процедура ПриУстановке(Знач КаталогУстановкиПакета, СтандартнаяОбработка) Экспорт");
	ЗаписьТекста.ЗаписатьСтроку("	// TODO: Реализуйте спец. логику установки, если требуется");
	ЗаписьТекста.ЗаписатьСтроку("КонецПроцедуры");
	ЗаписьТекста.ЗаписатьСтроку(Символы.ПС);
		
КонецПроцедуры

Процедура ЗаписатьЗаготовкуСкриптаСборки(Знач ЗаписьТекста)
	
	Лог.Информация("Создаю заготовку процедур сборки");
	
	ЗаписьТекста.ЗаписатьСтроку("///////////////////////////////////////////////////////////////////");
	ЗаписьТекста.ЗаписатьСтроку("// Процедуры сборки пакета                                          ");
	ЗаписьТекста.ЗаписатьСтроку("///////////////////////////////////////////////////////////////////
	|
	|");
	
	ЗаписьТекста.ЗаписатьСтроку("// Вызывается пакетным менеджером перед началом сборки пакета.");
	ЗаписьТекста.ЗаписатьСтроку("// ");
	ЗаписьТекста.ЗаписатьСтроку("// Параметры:");
	ЗаписьТекста.ЗаписатьСтроку("//   РабочийКаталог - Строка - Текущий рабочий каталог с исходниками пакета.");
	ЗаписьТекста.ЗаписатьСтроку("// ");
	ЗаписьТекста.ЗаписатьСтроку("Процедура ПередСборкой(Знач РабочийКаталог) Экспорт");
	ЗаписьТекста.ЗаписатьСтроку("	// TODO: Реализуйте спец. логику сборки, если требуется");
	ЗаписьТекста.ЗаписатьСтроку("КонецПроцедуры");
	ЗаписьТекста.ЗаписатьСтроку(Символы.ПС);
	
	ЗаписьТекста.ЗаписатьСтроку("// Вызывается пакетным менеджером после помещения файлов в пакет.");
	ЗаписьТекста.ЗаписатьСтроку("// ");
	ЗаписьТекста.ЗаписатьСтроку("// Параметры:");
	ЗаписьТекста.ЗаписатьСтроку("//   РабочийКаталог - Строка - Текущий рабочий каталог с исходниками пакета.");
	ЗаписьТекста.ЗаписатьСтроку("//   АрхивПакета - ЗаписьZIPФайла - ZIP-архив с содержимым пакета (включаемые файлы).");
	ЗаписьТекста.ЗаписатьСтроку("// ");
	ЗаписьТекста.ЗаписатьСтроку("Процедура ПриСборке(Знач РабочийКаталог, Знач АрхивПакета) Экспорт");
	ЗаписьТекста.ЗаписатьСтроку("	// TODO: Реализуйте спец. логику сборки, если требуется");
	ЗаписьТекста.ЗаписатьСтроку("	// АрхивПакета.Добавить(ПолныйПутьНужногоФайла,
	|	//	РежимСохраненияПутейZIP.СохранятьОтносительныеПути,
	|	//	РежимОбработкиПодкаталоговZIP.ОбрабатыватьРекурсивно);");
	ЗаписьТекста.ЗаписатьСтроку("КонецПроцедуры");
	ЗаписьТекста.ЗаписатьСтроку(Символы.ПС);
	
	ЗаписьТекста.ЗаписатьСтроку("// Вызывается пакетным менеджером после сборки пакета.");
	ЗаписьТекста.ЗаписатьСтроку("// ");
	ЗаписьТекста.ЗаписатьСтроку("// Параметры:");
	ЗаписьТекста.ЗаписатьСтроку("//   РабочийКаталог - Строка - Текущий рабочий каталог с исходниками пакета.");
	ЗаписьТекста.ЗаписатьСтроку("//   ПутьКФайлуПакета - Строка - Полный путь к собранному файлу пакета.");
	ЗаписьТекста.ЗаписатьСтроку("// ");
	ЗаписьТекста.ЗаписатьСтроку("Процедура ПослеСборки(Знач РабочийКаталог, Знач ПутьКФайлуПакета) Экспорт");
	ЗаписьТекста.ЗаписатьСтроку("	// TODO: Реализуйте спец. логику сборки, если требуется");
	ЗаписьТекста.ЗаписатьСтроку("КонецПроцедуры");
	ЗаписьТекста.ЗаписатьСтроку(Символы.ПС);
	
КонецПроцедуры

Процедура ЗаписатьЗаготовкуЗагрузкиБиблиотеки(Знач Каталог)
	
	ЗаписьТекста = Новый ЗаписьТекста(ОбъединитьПути(Каталог, "package-loader.os"));

	Лог.Информация("Создаю заготовку загрузки как библиотеки");
	
	ЗаписьТекста.ЗаписатьСтроку("///////////////////////////////////////////////////////////////////");
	ЗаписьТекста.ЗаписатьСтроку("// Процедуры подключение приложения как библиотеки                 ");
	ЗаписьТекста.ЗаписатьСтроку("///////////////////////////////////////////////////////////////////
	|
	|");
	
	ЗаписьТекста.ЗаписатьСтроку("#Использовать ""src/core""");
	ЗаписьТекста.ЗаписатьСтроку("// ");
	ЗаписьТекста.ЗаписатьСтроку("Процедура ПриЗагрузкеБиблиотеки(Путь, СтандартнаяОбработка, Отказ)");
	ЗаписьТекста.ЗаписатьСтроку("	СтандартнаяОбработка = Ложь;");
	ЗаписьТекста.ЗаписатьСтроку("КонецПроцедуры");
	ЗаписьТекста.ЗаписатьСтроку(Символы.ПС);
	
	ЗаписьТекста.Закрыть();
	
КонецПроцедуры

Процедура ПодготовитьИсполняемыйКаталог(Каталог, ОписаниеПриложения)

	ЗаписьТекста = Новый ЗаписьТекста(ОбъединитьПути(Каталог, НРег(ОписаниеПриложения.НаименованиеПриложения)+".os"));
	Лог.Информация("Создаю заготовку исполняемого файла");
	Текст = ТекстИсполняемогоФайлаПриложения();
	
	ВыполнитьПодстановкуПараметровВШаблон(Текст, ОписаниеПриложения);
	ЗаписьТекста.Записать(Текст);
	ЗаписьТекста.Закрыть();

	ЗаписьТекста = Новый ЗаписьТекста(ОбъединитьПути(Каталог, "Модули", "ПараметрыПриложения.os"));
	Лог.Информация("Создаю заготовку файла параметров приложения");
	Текст = ТекстФайлаПараметрыПриложения();
	
	ВыполнитьПодстановкуПараметровВШаблон(Текст, ОписаниеПриложения);
	ЗаписьТекста.Записать(Текст);
	ЗаписьТекста.Закрыть();
	
КонецПроцедуры

Функция ПрочитатьФайл(Знач ПутькФайлу)

	ЧтениеТекста = Новый ЧтениеТекста;
	ЧтениеТекста.Открыть(ПутькФайлу);
	Текст = ЧтениеТекста.Прочитать();

	Возврат Текст;

КонецФункции

Функция ТекстИсполняемогоФайлаПриложения()
	
	Возврат ПрочитатьФайл(ОбъединитьПути(ТекущийСценарий().Каталог, "../templates/ИсполняемыйФайл.tpl.os"));

КонецФункции


Функция ТекстФайлаПараметрыПриложения()
	
	Возврат ПрочитатьФайл(ОбъединитьПути(ТекущийСценарий().Каталог,"../templates/ПараметрыПриложения.tpl.os"));

КонецФункции

Функция ТекстФайлаКомандыПриложения()
	
	Возврат ПрочитатьФайл(ОбъединитьПути(ТекущийСценарий().Каталог,"../templates/КомандаПриложения.tpl.os"));

КонецФункции


Процедура ВыполнитьПодстановкуПараметровВШаблон(Текст, ОписаниеПриложения)

	Для каждого КлючЗначение Из ОписаниеПриложения Цикл
		
		Текст = СтрЗаменить(Текст, "<"+КлючЗначение.Ключ+">", КлючЗначение.Значение);

	КонецЦикла;
	

КонецПроцедуры


ИмяФайлаСпецификацииПакета = "packagedef";

Лог = ПараметрыПриложения.Лог();
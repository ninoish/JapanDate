# JapanDate

Salesforce Apexで日本の祝日を取得するためのクラス。
Dateクラスのメソッドも、基本的に使えます。


## サンプルコード
```
JapanDate jd1 = JapanDate.newInstance(2011, 10, 10);
System.debug(jd1.isHoliday()); // true
System.debug(jd1.holiday()); // 体育の日

Date dt2 = Date.newInstance(2019, 4, 30);
JapanDate jd2 = new JapanDate(dt2);
System.debug(jd2.holiday()); // 国民の休日

JapanDate jd3 = JapanDate.newInstance(2019, 12, 11);
System.debug(jd3.isHoliday()); // false
System.debug(jd3.holiday()); // null

JapanDate jd4 = JapanDate.newInstance(1990, 1, 1);
System.debug(jd4.holiday()); // 元日

JapanDate jd5 = JapanDate.newInstance(2019, 8, 12);
System.debug(jd5.isHoliday()); // true
System.debug(jd5.holiday()); // 山の日(振替休日)

JapanDate jd6 = JapanDate.newInstance(2019, 9, 23);
System.debug(jd6.holiday()); // 秋分の日

JapanDate jd7 = JapanDate.newInstance(2019, 3, 21);
System.debug(jd7.holiday()); // 春分の日

```

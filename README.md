# JapanDate

Salesforce Apexで日本の祝日を取得するためのクラス。
祝日・国民の休日・振替休日に対応

[Dateクラス](https://developer.salesforce.com/docs/atlas.ja-jp.222.0.apexcode.meta/apexcode/apex_methods_system_datetime.htm)のメソッドも基本的に使えますが、Dateクラスのように比較演算式には使えません。


## 独自メソッド
- public Boolean isHoliday() : 祝日・国民の休日・振替休日の場合、true。
- public String holiday() : 祝日・国民の休日・振替休日の名前を返す。それ以外はnull。
- public Integer dayOfWeek() : 0:日曜, 6:土曜
- public Date getDate() : Date型を返す

## サンプルコード
```
// newInstanceで初期化
JapanDate jd1 = JapanDate.newInstance(2011, 10, 10);
System.debug(jd1.isHoliday()); // true
System.debug(jd1.holiday()); // 体育の日

// Dateクラスから初期化
Date dt2 = Date.newInstance(2019, 4, 30);
JapanDate jd2 = new JapanDate(dt2);
System.debug(jd2.holiday()); // 国民の休日

// 祝日以外はnull
JapanDate jd3 = JapanDate.newInstance(2019, 12, 11);
System.debug(jd3.isHoliday()); // false
System.debug(jd3.holiday()); // null

JapanDate jd4 = JapanDate.newInstance(1990, 1, 1);
System.debug(jd4.holiday()); // 元日

JapanDate jd5 = JapanDate.newInstance(2019, 8, 11);
System.debug(jd5.isHoliday()); // true
System.debug(jd5.holiday()); // 山の日

JapanDate jd6 = JapanDate.newInstance(2019, 8, 12);
System.debug(jd6.isHoliday()); // true
System.debug(jd6.holiday()); // 振替休日(山の日)

JapanDate jd7 = JapanDate.newInstance(2019, 9, 23);
System.debug(jd7.holiday()); // 秋分の日

JapanDate jd8 = JapanDate.newInstance(2019, 3, 21);
System.debug(jd8.holiday()); // 春分の日

```

## 免責
本コードは Lightning Platform の技術検証をかねて個人として作成したものであり、動作の正確性、セキュリティ上の安全性などについて保証するものではありません。Lightning Platform の実装のサンプルコードとして個人として公開するものです。

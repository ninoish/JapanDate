public class JapanDate  {

    // 参考: https://qiita.com/chiyoyo/items/539dc2840a1b70a8e2c3

    // Dateクラスを継承できないので、Dateクラスのメソッドは全てコピー
    // Non-virtual and non-abstract type cannot be extended: Date
    private Date dt;

    // Dateクラスは、staticメソッド経由でしかインスタンス化できないが、
    // JapanDateはDateクラスを引数にインスタンス化を許容
    public JapanDate(Date dt) {
        this.dt = dt;
    }

    private class Holiday {
        String type;
        Integer month;
        Integer dayOrWeek;
        Integer startYear;
        Integer endYear;
        String name;

        Holiday(String type, Integer month, Integer dayOrWeek, Integer startYear, Integer endYear, String name) {
            this.type = type;
            this.month = month;
            this.dayOrWeek = dayOrWeek;
            this.startYear = startYear;
            this.endYear = endYear;
            this.name = name;
        }
    }

    /** 祝日一覧 */
    // 種別：
    //   fixed=日付固定
    //   happy=指定の週の月曜日
    //   spring=春分の日専用
    //   autumn=秋分の日専用
    private static final List<Holiday> HOLIDAYS = new List<Holiday>{
        // 種別, 月, 日or週, 開始年, 終了年, 祝日名
        new Holiday('fixed',   1,  1, 1949, 9999, '元日'),
        new Holiday('fixed',   1, 15, 1949, 1999, '成人の日'),
        new Holiday('happy',   1,  2, 2000, 9999, '成人の日'),
        new Holiday('fixed',   2, 11, 1967, 9999, '建国記念の日'),
        new Holiday('fixed',   2, 23, 2020, 9999, '天皇誕生日'),
        new Holiday('spring',  3,  0, 1949, 9999, '春分の日'),
        new Holiday('fixed',   4, 29, 1949, 1989, '天皇誕生日'),
        new Holiday('fixed',   4, 29, 1990, 2006, 'みどりの日'),
        new Holiday('fixed',   4, 29, 2007, 9999, '昭和の日'),
        new Holiday('fixed',   5,  3, 1949, 9999, '憲法記念日'),
        new Holiday('fixed',   5,  4, 1988, 2006, '国民の休日'),
        new Holiday('fixed',   5,  4, 2007, 9999, 'みどりの日'),
        new Holiday('fixed',   5,  5, 1949, 9999, 'こどもの日'),
        new Holiday('happy',   7,  3, 2021, 9999, '海の日'),
        new Holiday('fixed',   7, 23, 2020, 2020, '海の日'),
        new Holiday('happy',   7,  3, 2003, 2019, '海の日'),
        new Holiday('fixed',   7, 20, 1996, 2002, '海の日'),
        new Holiday('fixed',   8, 11, 2021, 9999, '山の日'),
        new Holiday('fixed',   8, 10, 2020, 2020, '山の日'),
        new Holiday('fixed',   8, 11, 2016, 2019, '山の日'),
        new Holiday('autumn',  9,  0, 1948, 9999, '秋分の日'),
        new Holiday('fixed',   9, 15, 1966, 2002, '敬老の日'),
        new Holiday('happy',   9,  3, 2003, 9999, '敬老の日'),
        new Holiday('fixed',  10, 10, 1966, 1999, '体育の日'),
        new Holiday('happy',  10,  2, 2000, 2019, '体育の日'),
        new Holiday('fixed',   7, 24, 2020, 2020, 'スポーツの日'),
        new Holiday('happy',  10,  2, 2021, 9999, 'スポーツの日'),
        new Holiday('fixed',  11,  3, 1948, 9999, '文化の日'),
        new Holiday('fixed',  11, 23, 1948, 9999, '勤労感謝の日'),
        new Holiday('fixed',  12, 23, 1989, 2018, '天皇誕生日'),
        //以下、1年だけの祝日
        new Holiday('fixed',   4, 10, 1959, 1959, '皇太子明仁親王の結婚の儀'),
        new Holiday('fixed',   2, 24, 1989, 1989, '昭和天皇の大喪の礼'),
        new Holiday('fixed',  11, 12, 1990, 1990, '即位礼正殿の儀'),
        new Holiday('fixed',   6,  9, 1993, 1993, '皇太子徳仁親王の結婚の儀'),
        new Holiday('fixed',   5,  1, 2019, 2019, '天皇の即位の日'),
        new Holiday('fixed',  10, 22, 2019, 2019, '即位礼正殿の儀')
    };

    /* CONSTANTS */
    private static final JapanDate SUBSTITUTE_HOLIDAY_ISSUED = JapanDate.newInstance(1973, 4, 12);
    private static final JapanDate SUNDAY = JapanDate.newInstance(1, 1, 2);
    private static final JapanDate NATIONAL_HOLIDAY_ISSUED = JapanDate.newInstance(2003,1,1);
    private static final Integer SUBSTITUTE_HOLIDAY_LAW_REVISED_YEAR = 2006;

    // 平日、振替休日、祝日の名前。平日の場合はnullを返す。
    public String holiday() {
        // 祝日
        String holiday = this.getUsualHolidayName();
        if (holiday != null) return holiday;

        // 振替休日
        holiday = this.getSubstituteHolidayName();
        if (holiday != null) return holiday;

        // 国民の休日
        return this.getNationalHolidayName();
    }

    /**
    * 祝日を取得
    */
    public Boolean isHoliday() {
        // 祝日
        String holiday = this.getUsualHolidayName();
        if (holiday != null) return true;

        // 振替休日
        holiday = this.getSubstituteHolidayName();
        if (holiday != null) return true;

        // 国民の休日チェック
        return this.getNationalHolidayName() != null;
    }

    /**
    * 設定された休日のみチェック
    * 国民の休日と振替休日はチェックしない
    */
    public String getUsualHolidayName() {
        String holiday = null;
        // 全ての祝日を判定
        for(Holiday h : HOLIDAYS) {
            switch on h.type {
                when 'fixed' {
                    holiday = this.fixedHoliday(h);
                }
                when 'happy' {
                    holiday = this.happyHoliday(h);
                }
                when 'autumn' {
                    holiday = this.autumnHoliday(h);
                }
                when 'spring' {
                    holiday = this.springHoliday(h);
                }
                when else {
                    System.debug('unknown type');
                }
            }
            if(holiday != null) return holiday;
        }
        return holiday;
    }

    /**
    * 振替休日チェック
    */
    public String getSubstituteHolidayName()
    {
        // 施行日チェック
        if (this.getDate() < SUBSTITUTE_HOLIDAY_ISSUED.getDate()) return null;

        // 当日が祝日の場合はfalse
        if (this.getUsualHolidayName() != null) return null;

        //改正法なら最大7日間遡る
        Integer num = (this.year() <= SUBSTITUTE_HOLIDAY_LAW_REVISED_YEAR) ? 1 : 7;

        JapanDate comp = this.addDays(-1);
        String result = null;
        for (Integer i = 0 ; i < num ; i++) {
            String holidayName = comp.getUsualHolidayName();
            if (holidayName != null) {
                // 祝日かつ日曜ならば振替休日
                if (comp.dayOfWeek() == 0) {
                    result = holidayName;
                    break;
                }
                comp = comp.addDays(-1);
            } else {
                break;
            }
        }
        return result == null ? null : '振替休日(' + result + ')';
    }

    /**
    * 国民の休日チェック
    * 1日前と1日後が祝日の場合、間の平日も休日になる。
    */
    public String getNationalHolidayName()
    {
        // 施行日チェック
        if (this.getDate() < NATIONAL_HOLIDAY_ISSUED.getDate()) return null;

        JapanDate before = this.addDays(-1);
        if (before.getUsualHolidayName() == null) return null;
        JapanDate after = this.addDays(1);
        if (after.getUsualHolidayName() == null) return null;
        return '国民の休日';
    }

    /**
    * 固定祝日かどうか
    */
    private String fixedHoliday(Holiday h)
    {
        if (!this.isWithinYear(h.startYear, h.endYear)) return null;
        if (this.month() != h.month) return null;
        if (this.day() != h.dayOrWeek) return null;
        return h.name;
    }

    /**
    * ハッピーマンデー
    */
    private String happyHoliday(Holiday h) {
        if (!this.isWithinYear(h.startYear, h.endYear)) return null;
        if (this.month() != h.month) return null;

        // 第*月曜日の日付を求める
        Integer w = 1; // 月曜日固定
        JapanDate d1 = this.toStartOfMonth();
        Integer w1 = d1.dayOfWeek();
        Integer day  = w - w1 < 0 ? 7 + w - w1 : w - w1;
        day++;
        day = day + 7 * (h.dayOrWeek - 1);
        if (this.day() != day) return null;
        return h.name;
    }

    /**
    * 春分の日
    */
    private String springHoliday(Holiday h) {
        if (!this.isWithinYear(h.startYear, h.endYear)) return null;
        if (this.month() != h.month) return null;

        Integer day = (Integer) Math.floor(20.8431 + 0.242194 * (this.year() - 1980) - Math.floor((this.year() - 1980) / 4));

        if (this.day() != day) return null;
        return h.name;
    }

    /**
    * 秋分の日
    */
    private String autumnHoliday(Holiday h)
    {
        if (!this.isWithinYear(h.startYear, h.endYear)) return null;
        if (this.month() != h.month) return null;

        Integer day = (Integer) Math.floor(23.2488 + 0.242194 * (this.year() - 1980) - Math.floor((this.year() - 1980) / 4));

        if (this.day() != day) return null;
        return h.name;
    }

    /**
    * 年が祝日適用範囲内であるか
    */
    private Boolean isWithinYear(Integer startYear, Integer endYear) {
        if (this.year() < startYear || endYear < this.year()) {
            return false;
        }
        return true;
    }

    /**
    * Dateクラスのインスタンスメソッド
    */

    public Date getDate() {
        return this.dt;
    }

    public Integer dayOfWeek() {
        return Math.mod(SUNDAY.daysBetween(this), 7);
    }

    public JapanDate addDays(Integer additionalDays) {
        Date dt = this.dt.addDays(additionalDays);
        return new JapanDate(dt);
    }

    public JapanDate addMonths(Integer additionalMonths) {
        Date dt = this.dt.addMonths(additionalMonths);
        return new JapanDate(dt);
    }

    public JapanDate addYears(Integer additionalYears) {
        Date dt = this.dt.addYears(additionalYears);
        return new JapanDate(dt);
    }

    public Integer day() {
        return this.dt.day();
    }

    public Integer dayOfYear() {
        return this.dt.dayOfYear();
    }

    public Integer daysBetween(Date secondDate) {
        return this.dt.daysBetween(secondDate);
    }

    public Integer daysBetween(JapanDate secondDate) {
        return this.dt.daysBetween(secondDate.getDate());
    }

    public String format() {
        return this.dt.format();
    }

    public Boolean isSameDay(Date dateToCompare) {
        return this.dt.isSameDay(dateToCompare);
    }

    public Boolean isSameDay(JapanDate dateToCompare) {
        return this.dt.isSameDay(dateToCompare.getDate());
    }

    public Integer month() {
        return this.dt.month();
    }

    public Integer monthsBetween(Date secondDate) {
        return this.dt.monthsBetween(secondDate);
    }

    public Integer monthsBetween(JapanDate secondDate) {
        return this.dt.monthsBetween(secondDate.getDate());
    }

    public JapanDate toStartOfMonth() {
        Date dt = this.dt.toStartOfMonth();
        return new JapanDate(dt);
    }

    public JapanDate toStartOfWeek() {
        Date dt = this.dt.toStartOfWeek();
        return new JapanDate(dt);
    }

    public Integer year() {
        return this.dt.year();
    }


    /**
    * DateクラスのStaticメソッド
    */

    public static Integer daysInMonth(Integer year, Integer month) {
        return Date.daysInMonth(year, month);
    }

    // holidaysInMonth()

    public static Boolean isLeapYear(Integer year) {
        return Date.isLeapYear(year);
    }

    public static JapanDate newInstance(Integer year, Integer month, Integer day) {
        Date dt = Date.newInstance(year, month, day);
        return new JapanDate(dt);
    }

    public static JapanDate parse(String stringDate) {
        Date dt = Date.parse(stringDate);
        return new JapanDate(dt);
    }

    public static JapanDate today() {
        Date dt = Date.today();
        return new JapanDate(dt);
    }

    public static JapanDate valueOf(String stringDate) {
        Date dt = Date.valueOf(stringDate);
        return new JapanDate(dt);
    }

    public static JapanDate valueOf(Object fieldValue) {
        Date dt = Date.valueOf(fieldValue);
        return new JapanDate(dt);
    }

}
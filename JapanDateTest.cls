@isTest
private class JapanDateTest {

    @isTest
    private static void testMethod() {
        JapanDate jd1 = JapanDate.newInstance(2011, 10, 10);
        JapanDate jd2 = JapanDate.newInstance(2019, 4, 30);
        JapanDate jd3 = JapanDate.newInstance(2019, 12, 11);
        JapanDate jd4 = JapanDate.newInstance(1990, 1, 1);
        JapanDate jd5 = JapanDate.newInstance(2019, 8, 12);
        JapanDate jd6 = JapanDate.newInstance(2019, 9, 23);
        JapanDate jd7 = JapanDate.newInstance(2019, 3, 21);
        System.debug(jd1.isHoliday());
        System.debug(jd1.holiday());

        System.debug(jd2.isHoliday());
        System.debug(jd2.holiday());

        System.debug(jd3.isHoliday());
        System.debug(jd3.holiday());

        System.debug(jd4.isHoliday());
        System.debug(jd4.holiday());

        System.debug(jd5.isHoliday());
        System.debug(jd5.holiday());

        System.debug(jd6.isHoliday());
        System.debug(jd6.holiday());

        System.debug(jd7.isHoliday());
        System.debug(jd7.holiday());

    }

}

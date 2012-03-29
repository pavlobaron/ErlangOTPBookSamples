package org.pbit.erlang.sample.lib;

import com.ericsson.otp.erlang.*;

import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

public class LibExample {

    protected OtpNode node;
    protected OtpMbox mb;

    public LibExample() throws Exception {
        node = new OtpNode("example", "secret");
        mb = node.createMbox("java");
    }

    public static void main(String [ ] args) {
        try {
            LibExample le = new LibExample();
            le.doit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    protected void doit() throws Exception {
        while (true) {
            try {
                OtpErlangTuple msg = (OtpErlangTuple)mb.receive();
                OtpErlangPid pid = (OtpErlangPid)msg.elementAt(0);
                String date = ((OtpErlangString)msg.elementAt(1)).toString();
                String format = ((OtpErlangString)msg.elementAt(2)).toString();

                System.out.println("Received: {" + date + ", " + format + "}");

                SimpleDateFormat df = new SimpleDateFormat(format);
                Date dt = df.parse(date, new ParsePosition(0));

                GregorianCalendar cal = new GregorianCalendar();
                cal.setTime(dt);

                OtpErlangObject[] adt = {
                    new OtpErlangInt(cal.get(Calendar.YEAR)),
                    new OtpErlangInt(cal.get(Calendar.MONTH)),
                    new OtpErlangInt(cal.get(Calendar.DAY_OF_MONTH))};
                OtpErlangTuple edt = new OtpErlangTuple(adt);

                OtpErlangObject[] at = {
                    new OtpErlangInt(cal.get(Calendar.HOUR_OF_DAY)),
                    new OtpErlangInt(cal.get(Calendar.MINUTE)),
                    new OtpErlangInt(cal.get(Calendar.SECOND))};
                OtpErlangTuple et = new OtpErlangTuple(at);

                OtpErlangObject[] ares = {edt, et};
                OtpErlangTuple res = new OtpErlangTuple(ares);
                OtpErlangObject[] amsg = {mb.self(), res};
                OtpErlangTuple bmsg = new OtpErlangTuple(amsg);

                System.out.println("Sending back: " + res.toString());

                mb.send(pid, bmsg);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}

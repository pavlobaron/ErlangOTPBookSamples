package org.pbit.erlang.sample.calc;

import com.ericsson.otp.erlang.*;

public class CalcExample {

    protected OtpNode node;
    protected OtpMbox mb;

    public CalcExample() throws Exception {
        node = new OtpNode("example", "secret");
        mb = node.createMbox("java");
    }

    public static void main(String [ ] args) {
        try {
            CalcExample le = new CalcExample();
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
                OtpErlangDouble a = (OtpErlangDouble)msg.elementAt(1);
                OtpErlangDouble b = (OtpErlangDouble)msg.elementAt(2);

                System.out.println("Received A = " + a.toString() + ", B = " + b.toString());

                OtpErlangObject res = new OtpErlangDouble(MathExample.calc(a.doubleValue(), b.doubleValue()));
                OtpErlangObject[] amsg = {mb.self(), res};
                OtpErlangTuple bmsg = new OtpErlangTuple(amsg);

                System.out.println("Sending back: " + bmsg.toString());

                mb.send(pid, bmsg);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}

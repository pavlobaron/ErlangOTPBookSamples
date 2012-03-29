package org.pbit.erlang.sample.riak;

import com.ericsson.otp.erlang.*;

public class RiakClient {

    private static String NODE = "example";
    private static String COOKIE = "riak";
    private static String ERLANG = "erlang";
    private static String CLIENT = "cl@127.0.0.1";

    protected OtpNode node;
    protected OtpMbox mb;

    public RiakClient() throws Exception {
        node = new OtpNode(NODE, COOKIE);
        mb = node.createMbox("java");
    }

    protected OtpErlangObject sendSyncMessage(OtpErlangObject obj) throws Exception {
        OtpErlangObject[] amsg = {mb.self(), obj};
        OtpErlangTuple bmsg = new OtpErlangTuple(amsg);

        System.out.println("Sending: " + bmsg.toString());

        mb.send(ERLANG, CLIENT, bmsg);

        OtpErlangTuple ret = (OtpErlangTuple)mb.receive(5000);

        System.out.println("Received: " + ret.toString());

        return ((OtpErlangTuple)ret).elementAt(1);
    }

    public boolean put(String bucket, String key, String[] value) throws Exception {
        OtpErlangBinary bbucket = new OtpErlangBinary(bucket);
        OtpErlangBinary bkey = new OtpErlangBinary(key);
        OtpErlangObject[] evalue = new OtpErlangObject[value.length];
        for (int i = 0; i < value.length; i++) evalue[i] = new OtpErlangString(value[i]);

        OtpErlangObject[] a = {new OtpErlangAtom("put"), bbucket, bkey, new OtpErlangList(evalue)};
        OtpErlangObject ret = sendSyncMessage(new OtpErlangTuple(a));

        return isOk(ret);
    }

    public String[] get(String bucket,  String key) throws Exception {
        OtpErlangBinary bbucket = new OtpErlangBinary(bucket);
        OtpErlangBinary bkey = new OtpErlangBinary(key);

        OtpErlangObject[] a = {new OtpErlangAtom("get"), bbucket, bkey};
        OtpErlangObject ret = sendSyncMessage(new OtpErlangTuple(a));
        if (ret instanceof OtpErlangList) {
            String[] values = new String[((OtpErlangList)ret).elements().length];
            for (int i = 0; i < ((OtpErlangList)ret).elements().length; i++) {
                values[i] = ((OtpErlangString)((OtpErlangList)ret).elementAt(i)).stringValue();
            }

            return values;
        } else return null;
    }

    public boolean delete(String bucket, String key) throws Exception {
        OtpErlangBinary bbucket = new OtpErlangBinary(bucket);
        OtpErlangBinary bkey = new OtpErlangBinary(key);

        OtpErlangObject[] a = {new OtpErlangAtom("delete"), bbucket, bkey};
        OtpErlangObject ret = sendSyncMessage(new OtpErlangTuple(a));

        return isOk(ret);
    }

    protected boolean isOk(OtpErlangObject what) throws Exception {
        return ((what instanceof OtpErlangAtom) && ((OtpErlangAtom)what).atomValue().equals("ok"));
    }
}

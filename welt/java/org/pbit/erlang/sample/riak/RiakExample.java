package org.pbit.erlang.sample.riak;

public class RiakExample {

    private static String BUCKET = "bucket1";
    private static String KEY = "key1";

    public static void main(String [ ] args) {
        try {
            RiakClient client = new RiakClient();
            String[] vals = {"initial value"};
            System.out.println("Putting a value: " + client.put(BUCKET, KEY, vals));

            vals = client.get(BUCKET, KEY);
            String s = "";
            for (String v : vals) s += v + ";";
            System.out.println("Getting a value: " + s);

            String[] newVals = new String[vals.length + 1];
            newVals[newVals.length - 1] = "new value";
            for (int i = 0; i < vals.length; i++) newVals[i] = vals[i];
            System.out.println("Putting a new value: " + client.put(BUCKET, KEY, newVals));

            vals = client.get(BUCKET, KEY);
            s = "";
            for (String v : vals) s += v + ";";
            System.out.println("Getting a value: " + s);

            System.out.println("Deleting a key: " + client.delete(BUCKET, KEY));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

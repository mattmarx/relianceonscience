import java.text.Normalizer;
import java.text.Normalizer.Form;
import java.util.ArrayList;
import java.util.List;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.StringTokenizer;


public class transliterate {
public static void main(String args[]) throws Exception {
	List<String> tokens = new ArrayList<>();
	BufferedReader br = null;
	try {
	 br = new BufferedReader(new InputStreamReader(System.in));
 	 StringTokenizer st = new StringTokenizer(br.readLine());
	 while (st != null && st.hasMoreElements()) {
          tokens.add(st.nextToken());
  	 }
	 for (int i = 0; i < tokens.size(); i++) {
 	  System.out.println(tokens.get(i));
          tokens.set(i, removeAccents(tokens.get(i)));
	 }
	 System.out.println(tokens);
	}
	catch (IOException e) {
	System.out.println(e);
	}
}
public static String removeAccents(String text) {
    return text == null ? null :
        Normalizer.normalize(text, Form.NFD)
            .replaceAll("\\p{InCombiningDiacriticalMarks}+", "");
}
}

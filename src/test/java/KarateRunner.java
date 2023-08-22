import com.intuit.karate.junit5.Karate;

public class KarateRunner {

    @Karate.Test
    Karate testRunner() {
        System.out.println("Test started");
        return Karate.run("classpath:features");
    }
}

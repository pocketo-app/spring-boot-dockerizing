package win.pocketo.springbootdockerizing;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class SpringBootDockerizingApplication {

	public static void main(String[] args) {
		SpringApplication.run(SpringBootDockerizingApplication.class, args);
	}

	@GetMapping("/")
	public String index() {
		return "Hello World";
	}

}

package nl.peterpopma.pi.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PiController
{
    @GetMapping("pi/{iterations}")
    public double getPi(@PathVariable Long iterations)
    {
        double value = 0, term;
        for (int i = 0; i<iterations; i++) {
            term = Math.pow(-1, i) / (2*i+1);
            value += term;
        }

        return 4 * value;
    }
}

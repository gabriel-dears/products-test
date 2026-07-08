package br.com.fiap.adj8.phase5.products.api

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/heart")
class HeartController {
    @GetMapping
    fun getMessage() = "Small services, shipped with care, deployed with confidence."
}

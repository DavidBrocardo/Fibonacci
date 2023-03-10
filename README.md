# Fibonacci
Resolvendo o problema matemático de Fibonacci em assembly 

**Problema:** \
  Construir um código iterativo que calcule o n-éssimo número fibonacci.
**Funcionamento:** \
* Deve ser solicitado ao usuário a entrada do n-éssimo número fibonacci buscado
  - A entrada é pelo teclado
  - uma string de caracteres ASCII que representa o número
  - máximo com 2 dígitos
  - usuário entrará sempre com 0, 1, 2 ou +3 dígitos e enter para finalizar
  - nunca caracteres alfabéticos ou especiais.
* Verificação de entrada
  - 1 ou 2 dígitos
    -verificação de limites de representação
  - n=0 ou +3 dígitos
    -mensagem de falha genérica, limpeza de buffer e encerramento
* Conversão dos dígitos ASCII para número equivalente
  - Exemplo: 34d é escrito como (10*3) + 4
* Caso a conversão tenha sucesso e o limite não tenha sido excedido
  - Calcular, de forma iterativa, fibonacci
    -fib(0) = 0
    -fib(1) = 1
    -fib(2) = fib(1) + fib(0)
    -fib(i) = fib(i-1) + fib(i-2)
* Para finalizar, grava em um arquivo binário
  - Nome do arquivo: fib(n).bin, onde n é a entrada do usuário
  - Conteúdo: resultado em “formato” binário

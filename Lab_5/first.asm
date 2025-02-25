format elf64
public _start

include 'func.asm'

section '.data' writable

buffer rb 1

section '.text' executable

_start:
   pop rcx ;читаем количество параметров командной строки
   cmp rcx, 3 ;если один параметр(имя исполняемого файла)
   jne .l1 ;завершаем работу

   mov rdi,[rsp+8] ;загружаем адрес имени файла из стека
   mov rax, 2 ;системный вызов открытия файла
   mov rsi, 0o ;Права только на чтение
   syscall ;выполняем системный вызов open
   cmp rax, 0 ;если вернулось отрицательное значение,
   jl .l1 ;то произошла ошибка открытия файла, также завершаем работу
   mov r8, rax ;сохраняем файловый дескриптор

   mov r10, [rsp+16] ;загружаем адрес символа, который подсчитывается
   xor r12, r12 ;обнуляем регистр r12
   mov r12L,  [r10] ;загружаем в младшую часть регистра символ, который будем искать
   
   
   
   xor r9, r9 ;обнуляем счетчик
 .loop_read: ;начинаем цикл чтения из файла
   mov rax, 0 ;номер системного вызова чтения
   mov rdi, r8 ;загружаем файловый дескриптор
   mov rsi, buffer ;указываем, куда помещать прочитанные данные
   mov rdx, 1 ;устанавливаем количество считываемых данных
   syscall ;выполняем системный вызов read
   cmp rax, 0 ;если прочитано 0 байт, то достигли конца файла 
   je .next  ;выходим из цикла чтения
   cmp [buffer], r12L ;проверяем совпадение
   jne pt1
   jne .loop_read
   inc r9
   pt1
   
   jmp .loop_read ;продолжаем цикл чтения
.next: 
   xchg rax, r9 ;возвращаем результат в rax
   call print_decimal
   call new_line
  ;;Системный вызов close
   mov rdi, r8
   mov rax, 3
   syscall
   
.l1:
   call exit
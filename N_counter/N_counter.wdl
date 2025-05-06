version 1.0

workflow N_counter {
  input {
    File fasta_file
  }

  call count_n {
    input:
      fasta = fasta_file
  }

  output {
    Int n = count_n.n
  }
}

task count_n {
    input {
        File fasta
    }
    command {
        grep -v '^>' ${fasta} | grep -o 'N' | wc -l
    }

    output {
        Int n = read_int(stdout())
    }
    runtime {
        preemptible: 3
        docker: "ubuntu:22.04"
    }


}

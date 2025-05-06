version 1.0

workflow N_counter {
  input {
    File fasta_file
  }

  call split_fasta {
    input:
      fasta = fasta_file
  }

  scatter (file in split_fasta.chromosomes) {   
    call count_n {
      input:
        fasta = file
    }
  }

  call sum_array {
    input:
      array = count_n.n
  }


  output {
    Array[Int] n = count_n.n
    Int total_n = sum_array.sum
  }

}

task split_fasta {
  input {
    File fasta
  }
  command {
    seqkit split -i -O split_chromosomes_dir ${fasta}
  }

  output {
    Array[File] chromosomes = glob("split_chromosomes_dir/*")
  }
  runtime {
    docker: "quay.io/biocontainers/seqkit:2.10.0--h9ee0642_0"
    preemptible: 3
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

task sum_array {
  input {
    Array[Int] array
  }
  command <<< 
    echo ~{sep=' ' array} | awk '{s=0; for (i=1; i<=NF; i++) s+=$i; print s}'
  >>>

  output {
    Int sum = read_int(stdout())
  }
  runtime {
    docker: "ubuntu:22.04"
    preemptible: 1
  }
}

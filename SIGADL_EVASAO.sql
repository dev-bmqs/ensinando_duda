select unid_nome as ies, octi.octi_descricao, peri.peri_descricao , peri.peri_id, nens_nome, curs_nome, ocor.alun_matricula

       , pessoa.*

from ocorrencia ocor

       join curso on (ocor.nens_id = curso.nens_id and ocor.curs_id=curso.curs_id)

       join nivel_ensino nens on (nens.nens_id = ocor.nens_id)

       join periodo_letivo peri on (ocor.peri_id = peri.peri_id)

       join ocorrencia_tipo octi on (ocor.octi_id_tipo=octi.octi_id)

       join aluno on (ocor.alun_matricula=aluno.alun_matricula)

       join pessoa on (aluno.pess_id = pessoa.pess_id)

       join unidade on (curso.unid_id = unidade.unid_id)

where octi_id_tipo=3

and peri_ano=2022 and peri_periodo=1

order by 1, 4

 

 

 

--

with tab_ocorrencia as (

       select ocor.alun_matricula, ocor.nens_id , ocor.curs_id, ocor.habi_id , ocor.turn_id , ocor.viac_sequencia , ocor.peri_id , ocor.ocor_data, ocor.ocor_obs , octi.octi_descricao

       from ocorrencia ocor

             join periodo_letivo peri on (peri.peri_id = ocor.peri_id)

             join ocorrencia_tipo octi on (ocor.octi_id_tipo=octi.octi_id)

       where ocor.octi_id_tipo in (1, 4, 7, 9, 11)

       and peri.peri_ano =2021

       and peri.peri_periodo=2

       and ocor.ocor_desfeita = false

)

select unid_nome as ies, peri.peri_ano::varchar||'/'||peri.peri_periodo::varchar as semestre, matr.alun_matricula as ra

       , pessoa.pess_nome, nens.nens_nome, curso.curs_nome, peri.peri_descricao, matr.data_hora_inc as data_matricula

       , (select count(1)

             from matricula_composicao maco

                    join status_matricula stma on (maco.stma_id = stma.stma_id)

             where maco.alun_matricula=matr.alun_matricula

                    and maco.nens_id = matr.nens_id

                    and maco.curs_id_aluno = matr.curs_id

                    and maco.habi_id_aluno = matr.habi_id

                    and maco.turn_id = matr.turn_id

                    and maco.viac_sequencia = matr.viac_sequencia

                    and maco.peri_id = matr.peri_id

                    and stma.stma_considera_matriculado

       ) as total_disciplinas_ativas

       , ocor.*

--, matr.*

from matricula matr

       join periodo_letivo peri on (matr.peri_id = peri.peri_id)

       join curso on (matr.nens_id = curso.nens_id and matr.curs_id=curso.curs_id)

       join nivel_ensino nens on (nens.nens_id = matr.nens_id)

       join aluno on (matr.alun_matricula=aluno.alun_matricula)

       join pessoa on (aluno.pess_id = pessoa.pess_id)

       join unidade on (curso.unid_id = unidade.unid_id)

       left join tab_ocorrencia ocor

             on (matr.alun_matricula = ocor.alun_matricula

                    and matr.nens_id = ocor.nens_id

                    and matr.curs_id = ocor.curs_id

                    and matr.habi_id = ocor.habi_id

                    and matr.turn_id = ocor.turn_id

                    and matr.viac_sequencia = ocor.viac_sequencia

                    and ocor.ocor_data > matr.data_hora_inc)

where peri.peri_ano = 2021

       and peri.peri_periodo = 2

order by 2, 5

 
#! /bin/csh -f

######################## First Run #########################
set current_dir = `pwd`
set scrape_ptt_path = '/Users/coslate/python_ex/Crawler/scrape_ptt'
set start_timing    = '20180614'
set end_timing      = '20170510'
set timeing_slot    = ${start_timing}_${end_timing}
set debug_path      = /Users/coslate/Word2Vec/debug_folder_${timeing_slot}

if ( -d $debug_path ) then
    rm -rf $debug_path
    mkdir $debug_path
else 
    mkdir $debug_path
endif

cd ./Preprocess
./preprocess.py -file Total_$timeing_slot -odir . -cdir $scrape_ptt_path/Total_20180614_20130510 -st $start_timing -et $end_timing -isd 1 -isp 1 > $debug_path/debug_1st_preprocess.$timeing_slot.log
cd $current_dir

cd ../Word_Segmentation
./word_segmentation.py -file ../Word2Vec/Preprocess/Total_${timeing_slot}_preprocessed/Total_${timeing_slot}_preprocessed_${timeing_slot}  -odir . -verb 1 > $debug_path/debug_1st_word_segmentation.$timeing_slot.log
cd $current_dir

# Word2Vec Generate Keywords and first word cloud
set team_list_eng = (   Warriors\
                        Pelicans\
                        Rockets\
                        Jazz\
                        Cavaliers\
                        Raptors\
                        76ers\
                        Celtics_0\
                        Celtics_1\
                        Celtics_2\
)

set team_list = (   勇士\
                    鵜鶘\
                    火箭\
                    爵士\
                    騎士\
                    暴龍\
                    76\
                    提克\
                    塞爾\
                    塞爾提克\
)

@ i = 1
foreach team ( $team_list )
    set out_name = "Total_${timeing_slot}_stop_$team_list_eng[$i]"

    if ($i == 1) then 
        ./word2vec_wordcloud.py -text_file ../Word_Segmentation/Total_${timeing_slot}_preprocessed_${timeing_slot}.segmentated -alg_sg 1 -window 50 -q_str $team -topn 400 -verb 1 -train 1 -out_name $out_name > $debug_path/debug_1st_word2vec.$timeing_slot.$team.log
    else
        ./word2vec_wordcloud.py -text_file ../Word_Segmentation/Total_{$timeing_slot}_preprocessed_${timeing_slot}.segmentated -alg_sg 1 -window 50 -q_str $team -topn 400 -verb 1 -train 0 -out_name $out_name > $debug_path/debug_1st_word2vec.$timeing_slot.$team.log
    endif
    @ i += 1
end

######################## Second Run #########################
#Grep only the aritcles that include keywords of one team from the corpus
cd ./Preprocess
foreach team ( $team_list_eng )
    set file = "Total_{$timeing_slot}_2nd_$team"
    set key = "../keyword_result_Total_${timeing_slot}_stop_$team"

    ./preprocess.py -file $file -odir . -cdir $scrape_ptt_path/Total_${timeing_slot} -st $start_timing -et $end_timing -isd 1 -isp 1 -key $key -thnum 100 -mkn 20 > $debug_path/debug_2nd_preprocess.$timeing_slot.$team.log
end
cd $current_dir

cd ../Word_Segmentation
foreach team ( $team_list_eng )
    set file = "../Word2Vec/Preprocess/Total_${timeing_slot}_2nd_${team}_preprocessed/Total_${timeing_slot}_2nd_${team}_preprocessed_${timeing_slot}"
    set stop_word_file = "./stopword_lib/stopwords.txt.$team"

    ./word_segmentation.py -file $file -odir . -verb 1 -stop_word_file $stop_word_file > $debug_path/debug_2nd_word_segmentation.$timeing_slot.$team.log
end
cd $current_dir

# Word2Vec Generate Keywords and 2nd word cloud
@ i = 1
foreach team ( $team_list )
    set out_name = "Total_${timeing_slot}_2nd_stop_$team_list_eng[$i]"
    set text_file = "../Word_Segmentation/Total_${timeing_slot}_2nd_$team_list_eng[$i]_preprocessed_${timeing_slot}.segmentated"

    ./word2vec_wordcloud.py -text_file $text_file -alg_sg 0 -window 50 -q_str $team -topn 400 -verb 1 -train 1 -out_name $out_name > $debug_path/debug_2nd_word2vec.$timeing_slot.$team.log
    @ i += 1
end

# Keyword Extraction and generate final word cloud
cd ../Keyword_Extraction_Form_Dictionary
@ i = 0
foreach team ( $team_list_eng )
    set out_name = "Total_${timeing_slot}_2nd_${team}.tfidf_word2vec"
    set text_file = "../Word_Segmentation/Total_${timeing_slot}_2nd_${team}_preprocessed_${timeing_slot}.segmentated"
    set stop_word_file = "../Word_Segmentation/stopword_lib/stopwords.txt.$team"
    set key_word_file = "../Word2Vec/keyword_result_Total_${timeing_slot}_2nd_stop_$team"

    ./keyword_extraction.py -text_file $text_file -topn 400 -out_name $out_name -stop_word_file $stop_word_file -key_file $key_word_file > $debug_path/debug_final_keyword_extraction.$timeing_slot.$team.log
    endif
    @ i += 1
end

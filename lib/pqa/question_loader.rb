module PQA
  class QuestionLoader
    def initialize
      uri     = "http://#{MockApiServerRunner::HOST}:#{MockApiServerRunner::PORT}"
      @client = ApiClient.new(uri, nil, nil, nil)
    end

    def load_and_import(n = 1)
      import    = Import.new
      questions = (1..n).map do |i|
        QuestionBuilder.default("uin-#{i}")
      end
      load(questions)
      import.run(Date.yesterday, Date.tomorrow)
      questions
    end

    def load(questions)
      @client.reset_mock_data!
      questions.each do |q|
        xml = XMLEncoder.encode_questions([q])
        @client.save_question(q.uin, xml)
      end
    end
  end
end

import 'dart:io';
import 'package:dart_openai/openai.dart';

class AIService {
  AIService() {
    OpenAI.apiKey = "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"; // Initialize the package with the API key
    OpenAI.organization = "org-2YkkE6qieHaCmPXsYoFecOsw"; // Optional:
  }


  Future<List<OpenAIModelModel>> listModels() async {
    return await OpenAI.instance.model.list();
  }

  //O mais usado
  Future<OpenAICompletionModel> createCompletion({
    required String model,
    required String prompt,
    
    int maxTokens = 1000,
    double temperature = 0.5,
    int n = 1,
    String stop = "\n",
    bool echo = true,
  }) async {
    return await OpenAI.instance.completion.create(
      model: model,
      prompt: prompt,
      maxTokens: maxTokens,
      temperature: temperature,
      n: n,
      stop: stop,
      echo: echo,
    );
  }


  Future<OpenAIChatCompletionModel> createChat({
      required String model,
      required List<OpenAIChatCompletionChoiceMessageModel> messages,
    }) async {
      return await OpenAI.instance.chat.create(
        model: model,
        messages: messages,
      );
    }

    Future<OpenAIEditModel> createEdit({
      required String model,
      required String instruction,
      required String input,
      required int n,
      required double temperature,
    }) async {
      return await OpenAI.instance.edit.create(
        model: model,
        instruction: instruction,
        input: input,
        n: n,
        temperature: temperature,
      );
    }

    Future<OpenAIImageModel> createImage({
      required String prompt,
      required int n,
      required OpenAIImageSize size,
      required OpenAIImageResponseFormat responseFormat,
    }) async {
      return await OpenAI.instance.image.create(
        prompt: prompt,
        n: n,
        size: size,
        responseFormat: responseFormat,
      );
    }

    Future<OpenAIEmbeddingsModel> createEmbedding({
      required String model,
      required String input,
    }) async {
      return await OpenAI.instance.embedding.create(
        model: model,
        input: input,
      );
    }

    Future<OpenAIAudioModel> createTranscription({
      required File file,
      required String model,
      required OpenAIAudioResponseFormat responseFormat,
    }) async {
      return await OpenAI.instance.audio.createTranscription(
        file: file,
        model: model,
        responseFormat: responseFormat,
      );
    }

    Future<OpenAIAudioModel> createTranslation({
      required File file,
      required String model,
      required OpenAIAudioResponseFormat responseFormat,
    }) async {
      return await OpenAI.instance.audio.createTranslation(
        file: file,
        model: model,
        responseFormat: responseFormat,
      );
    }

    Future<List<OpenAIFileModel>> listFiles() async {
      return await OpenAI.instance.file.list();
    }

    Future<OpenAIFileModel> uploadFile({
      required File file,
      required String purpose,
    }) async {
      return await OpenAI.instance.file.upload(
        file: file,
        purpose: purpose,
      );
  }
  
  
}

/*
@Envied(path: ".env")
abstract class Env {
  @EnviedField(varName: 'OPEN_AI_API_KEY') // the .env variable.
  static const apiKey = _Env.apiKey;
}*/



defmodule Proxy.ObjectStore do

  def get_blob_file_by_id(blob_id) do

    # TODO: AWS request

    File.read("store/#{blob_id}")
  end
end

# frozen_string_literal: true

def windows_facts
  {
    'docker_program_data_path'  => 'C:/ProgramData',
    'docker_program_files_path' => 'C:/Program Files',
    'docker_systemroot'         => 'C:/Windows',
    'docker_user_temp_path'     => 'C:/Users/Administrator/AppData/Local/Temp',
  }
end
